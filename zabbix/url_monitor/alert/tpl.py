#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: tpl.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-12-10 01:54:56
############################

def getHtmlContent(content):
	header = '''
<table border="0" cellspacing="0" cellpadding="1" 
style='width:600px;border:1px solid #ddd;font-family: "Helvetica Neue", "Luxi Sans", "DejaVu Sans", Tahoma, "Hiragino Sans GB", STHeiti, "Microsoft YaHei", Arial, sans-serif;box-shadow:0 0 20px #777;' >
<tr>
    <td   bgcolor="#319400" 
	style="padding-left:20px;color:#ffffff;font-weight:bold;font-size:40px;" height=60>
	API监控 - %s
    </td>
</tr>
''' %(status)

	title = '''
<tr>
    <td bgcolor="ffffff" style="padding:20px;" >
	<table border="0">
	    <tr>
		<td>
		    
		    <img src="http://stat.dnspod.cn/static/warning/%s.png" /> 
		</td>
		<td>
		    <p style="font-weight: bold;font-size:22px;margin:10px;padding:0;"> 接口 %s</p>
		</td>
	    </tr>
	</table>
    </td>
</tr>
''' %(img, desc)

	overview = '''
<tr>
    <td colspan="2" style="padding:0;background-color:#fff;">
	<table border="0" cellspacing="0" cellpadding="1">
	    <tr>
		<td  bgcolor="d4350e"   width="15" style="padding:0;"></td>
		<td style="color: #d4350e ;padding:10px; font-weight: bold;font-size:20px;">故障情况</td>
	    </tr>
	</table>
    </td>
</tr>
'''
	
