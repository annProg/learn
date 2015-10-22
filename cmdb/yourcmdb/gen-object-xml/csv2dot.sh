#!/bin/bash

############################
# Usage:
# File Name: csv2dot.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-10-21 13:22:57
############################

dir="object_csv_cmdb"
tmpfile=dot.file.tmp

function func1()
{
	echo -e "digraph cmdb {\n label=\"CMDB对象定义图示\"; \nfontsize=25;\n rankdir=TB;"
	for id in `ls $dir`;do
		echo -e "    subgraph cluster_$id {\n label=\"$id\";\n style=\"dotted\";\n"
		for file in `ls $dir/$id`;do
			object=`echo $file |cut -f1 -d'.'`
			echo "    \"$object\" [shape=\"doublecircle\", color=\"gray\", style=\"filled\", fillcolor=\"yellow\"];"
			cat $dir/$id/$file |sed '1d' |iconv -f gbk -t utf-8 >$tmpfile
			while read line;do
				name="$object_`echo $line |cut -f1 -d','`"
				name=${object}"_"${name}
				label=`echo $line |cut -f2 -d','`
				link=`echo $line |grep objectref |cut -f3 -d',' |cut -f2 -d'-'`
				echo "        \"$name\" [label=\"$label\", shape=\"record\"];"
				echo "        \"$object\" -> \"$name\";"
				[ "$link"x != ""x ] && echo "        \"$name\" -> \"$link\" [color=\"blue\",side=\"l\"];"
			done <$tmpfile
		done
		echo "}"
	done
	echo "}"
}

function func2()
{
	echo -e "digraph cmdb {\n label=\"CMDB对象定义图示\"; \nfontsize=25;\n rankdir=TB;"
	for id in `ls $dir`;do
		echo -e "    subgraph cluster_$id {\n         label=\"$id\";\nfontsize=20;\nfontcolor=gray7;\n style=\"rounded\";\n"
		for file in `ls $dir/$id`;do
			object=`echo $file |cut -f1 -d'.'`
			#node_object="    \"$object\" [color=\"skyblue\", shape=\"record\", label=\"{$object"
			node_object="    \"$object\" [color=\"skyblue\", shape=\"plaintext\", label=<<table border=\"0\" cellborder=\"1\" cellspacing=\"0\" align=\"left\"><tr><td bgcolor=\"skyblue\">$object</td></tr>"
			# 先保存到文件中，如果直接管道后接while读取，因为管道是fork一个新进程，while中的变量和while外面的不是同一个
			cat $dir/$id/$file |sed '1d' |iconv -f gbk -t utf-8 >$tmpfile
			while read line;do
				name=`echo $line |cut -f1 -d','`
				label=`echo $line |cut -f2 -d','`
				link=`echo $line |grep objectref |cut -f3 -d',' |cut -f2 -d'-'`
				#node_object="$node_object|<$name>$label"
				node_object="$node_object<tr><td port=\"$name\">$label</td></tr>"
				[ "$link"x != ""x ] && echo "        \"$object\":$name -> \"$link\" [color=\"blue\",side=\"l\"];"
			done <$tmpfile
			node_object=${node_object}"</table>>];"
			echo  "    $node_object"
		done
		echo "}"
	done
	echo "}"
	rm -f $tmpfile
}

func1 >cmdb_gen.dot
func2 >cmdb.dot
