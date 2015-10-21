#!/bin/bash

############################
# Usage:
# File Name: csv2dot.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-10-21 13:22:57
############################

dir="cmdb_object_csv"
tmpfile=dot.file.tmp

echo -e "digraph cmdb {\n rankdir=TB;"

function func1()
{
	for id in `ls $dir`;do
		for file in `ls $dir/$id`;do
			object=`echo $file |cut -f1 -d'.'`
			echo "    subgraph cluster_$object {"
			echo "    \"$object\" [shape=\"doublecircle\", color=\"gray\", style=\"filled\", fillcolor=\"yellow\"];"
			cat $dir/$id/$file |sed '1d' |while read line;do
				name="$object_`echo $line |cut -f1 -d','`"
				name=${object}"_"${name}
				label=`echo $line |cut -f2 -d','`
				link=`echo $line |grep objectref |cut -f3 -d',' |cut -f2 -d'-'`
				echo "        \"$name\" [label=\"$label\", shape=\"record\"];"
				echo "        \"$object\" -> \"$name\";"
				[ "$link"x != ""x ] && echo "        \"$name\" -> \"$link\" [color=\"blue\",side=\"l\"];"
			done
			echo "    }"
		done
	done
	echo "}"
}

function func2()
{
	for id in `ls $dir`;do
		echo -e "    subgraph cluster_$id {\n         label=\"$id\";"
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

func2
