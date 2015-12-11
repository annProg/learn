#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: tpl.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-12-10 01:54:56
############################
import sys  
reload(sys)  
sys.setdefaultencoding('utf8')

def itemProtoType(icon, itemkey, itemvalue):
	'''
	icon_clock_red 故障时间
	icon_reason  故障原因
	icon_swith   切换结果
	icon_link    链接
	icon_clock_green 恢复时间
	icon_clock     故障时长
	'''

	item = '''
<tr>
	<td width="30" height="30" align="center" valign="center"><img src="http://stat.dnspod.cn/static/warning/icon_%s.png" /></td>
	<td style="width:100;height:30; text-align:center;padding-right:10px;valign:top">%s</td>
	<td style="text-align:left;valign:top;padding-left:20px">%s</td>
 </tr> 
''' %(icon, itemkey, itemvalue)
	return(item)

def mailTemplate(argv):
	'''
	#319400  绿色 故障恢复
	#d4350e  红色 故障发生
	'''

	status = argv['status']
	name = argv['name']
	items = argv['items']

	if status == "OK":
		img = "ok"
		color = "#319400"
		desc = name
	else:
		img = "down"
		color = "#d4350e"
		desc = name

	header = '''
<table border="0" cellspacing="0" cellpadding="1" 
style='width:90%%;border:1px solid #ddd;font-family: "Helvetica Neue", "Luxi Sans", "DejaVu Sans", Tahoma, "Hiragino Sans GB", STHeiti, "Microsoft YaHei", Arial, sans-serif;box-shadow:0 0 20px #777;' >
<tr>
    <td   bgcolor="%s" 
	style="padding-left:20px;color:#ffffff;font-weight:bold;font-size:40px;" height=60>
	API监控 - %s
    </td>
</tr>
''' %(color, status)

	title = '''
<tr>
    <td bgcolor="ffffff" style="padding:20px;" >
	<table border="0">
	    <tr>
		<td>
		    
		    <img src="http://stat.dnspod.cn/static/warning/%s.png" /> 
		</td>
		<td>
		    <p style="font-weight: bold;font-size:22px;margin:10px;padding:0;">%s</p>
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
		<td  bgcolor=\"%s\"   width="15" style="padding:0;"></td>
		<td style="color: %s ;padding:10px; font-weight: bold;font-size:20px;">故障情况</td>
	    </tr>
	</table>
    </td>
</tr>
<tr>
    <td bgcolor="ffffff" style="font-size:16px;padding-left:30px;padding-top:10px;padding-bottom:15px;" >
	<table width="90%%" border="1" cellspacing="0" cellpadding="0">
''' %(color, color)

	item_all = ""
	for item in items:
		itemstr = itemProtoType(item['icon'], item['itemkey'], item['itemvalue'])
		item_all += itemstr

	footer = '''
</table>
    </td>
</tr>
<tr>
    <td colspan="2" style="padding:0;background-color:#fff;text-align:right;padding:20px;font-size:16px;">
	© LeTV Scloud
    </td>
</tr>
</table>
'''

	data = header + title + overview + item_all + footer
	return(data)

if __name__ == '__main__':
	argv = {}
	argv['name'] = "base_ota_getupgrade"
	argv['status'] = "up"
	argv['items'] = []
	argv['items'].append({"icon":"reson", "itemkey": "故障原因", "itemvalue":"无法连接"})
	print(mailTemplate(argv))
