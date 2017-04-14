#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage: 分析基于zabbix的app状态码监控数据（可以用influxdb取代）
# File Name: reqstat_analyze.py
# Created Time: 2015-10-23 11:15:33
############################

import item
import history
import json
import re
import sys
import datetime
import time
import numpy as np


if sys.argv[1] == "newtv":
	arg = ["10184", "rt"]
elif sys.argv[1] == "online":
	arg = ["10245", "rt"]
else:
	exit("args error")
# 功能
func = sys.argv[2]

basepath = "/root/report/"
today = time.strptime(str(datetime.date.today()), "%Y-%m-%d")
yesterday = time.strptime(str(datetime.date.today() - datetime.timedelta(days=1, seconds=60)), "%Y-%m-%d")
time_start = time.mktime(yesterday)
time_start = time_start - 360
time_till = time.mktime(today)

#print(yesterday)
tag = sys.argv[1]
data = item.getHostItem(arg)

appdata = {}
std = {} # 标准差
mean = {} # 平均响应时间
min = {} # 最小响应时间

# 需要排除的应用
regex = r"10\.*|vpsea*|tv-voddesktop|123\.*|115\.*|UNDEF*"

for record in data:
	app = record["key_"][3:-1]
	newreg = r"weather"
	if re.match(regex, app) or re.match(newreg, app):
		continue
	itemid = record["itemid"]
	
	argv = [itemid, time_start, time_till]
	values = history.getHistory(argv)
	
	# 如果数据量过小，说明应用访问量小，不计入统计
	if len(values)<1500:
		continue
	valuelist = []
	plotdata = []
	for value in values:
		valuelist.append(float(value["value"]))
		timeStr = time.strftime("%Y%m%d/%H:%M:%S", time.localtime(int(value["clock"])))
		plotdata.append({"time":timeStr, "value":value["value"]})
	appdata[app] = {}
	appdata[app]["itemid"] = itemid
	appdata[app]["values"] = valuelist
	appdata[app]["plotdata"] = plotdata
	
	if valuelist:
		std[app] = np.std(valuelist)
		mean[app] = np.mean(valuelist)
		min[app] = np.min(valuelist)

stdlist = sorted(std.items(), key=lambda d:d[1], reverse=True)
meanlist = sorted(mean.items(), key=lambda d:d[1], reverse=True)

plotcmd = ""

# 标准差分析
if func=="std":
	for i,record in enumerate(stdlist[:5]):
		top = record[0]
		file_name = basepath + "plot_std_" + tag + "_" + str(i+1) + ".plt"
		file = open(file_name, 'w')
		file.close()
		
		for j in appdata[top]["plotdata"]:
			with open(file_name, 'a+') as f:
				f.write(j["time"] + " " + j["value"] + "\n")
		#if i<3:
		#	linewidth = 3
		#else:
		#	linewidth = 1
		linewidth = 1
		plotcmd += "\"" + file_name + "\" using 1:2 title \"" + top + " (" + str("%.2f"%record[1]) + ")" + "\" with lines linewidth " + str(linewidth) + ","	
		#plotcmd += "\"" + file_name + "\" using 1:2 title \"" + top + " (" + str("%.2f"%record[1]) + ")" + "\" with lines linewidth " + str(linewidth) + " smooth bezier,"	

# 平均值分析
if func=="mean":
	file_name = basepath + "plot_mean_" + tag  + ".plt"
	file = open(file_name, 'w')
	file.close()
	for j in meanlist[:10]:
		jlist = list(j)
		with open(file_name, 'a+') as f:
			f.write(jlist[0] + " " + str(jlist[1]) + " " + str(min[jlist[0]]) + "\n")
	plotcmd += "\"" + file_name + "\" using 2:xtic(1) title \"Mean\",'' using 3 title \"Min\"" + ","	


# 5xx分析
if func=="5xx":
	data5xx = {}
	count = {}
	maxvalue = {}
	arg[1] = "http_5xx"
	data = item.getHostItem(arg)
	newreg = r"weather"
	for record in data:
		app = record["key_"][9:-1]
		if re.match(regex, app) or re.match(newreg, app):
			continue
		
		itemid = record["itemid"]
		argv = [itemid, time_start, time_till]
		values = history.getHistory(argv)
		
		valuelist = []
		plotdata = []
		for value in values:
			rate = float(value["value"])
			if rate > 0.1:
				valuelist.append(float(value["value"]))
			timeStr = time.strftime("%Y%m%d/%H:%M:%S", time.localtime(int(value["clock"])))
			plotdata.append({"time":timeStr, "value":value["value"]})
		data5xx[app] = {}
		data5xx[app]["itemid"] = itemid
		data5xx[app]["values"] = valuelist
		data5xx[app]["plotdata"] = plotdata
		count[app] = len(valuelist)
		if valuelist:
			maxvalue[app] = np.max(valuelist)
		else:
			maxvalue[app] = 0

	#print(count,maxvalue)
	countlist = sorted(count.items(), key=lambda d:d[1], reverse=True)
	for i,record in enumerate(countlist[:5]):
		top = record[0]
		if maxvalue[top] == 0:
			continue
		file_name = basepath + "plot_5xx_" + tag + "_" + str(i+1) + ".plt"
		file = open(file_name, 'w')
		file.close()

		for j in data5xx[top]["plotdata"]:
			with open(file_name, 'a+') as f:
				f.write(j["time"] + " " + j["value"] + "\n")
		#if i<3:
		#	linewidth = 3
		#else:
		#	linewidth = 1
		linewidth = 1
		plotcmd += "\"" + file_name + "\" using 1:2 title \"" + top + " (" + str(record[1]) + ")" + "\" with lines linewidth " + str(linewidth) + ","

# 请求量分析
if func=="req":
	datareq = {}
	unexpected = {}
	arg[1] = "req_total"
	data = item.getHostItem(arg)
	#data = [{"itemid": "127148", "key_": "req_total[xsquare]"}]

	for record in data:
		app = record["key_"][10:-1]
		if re.match(regex, app):
			continue
		
		itemid = record["itemid"]
		argv = [itemid, time_start, time_till]
		values = history.getHistory(argv)
		length = len(values)
		ratelist = []
		plotdata = []
		
		for i,value in enumerate(values):
			next = i+4
			pre = i-2
			if pre < 0:
				continue
			if next >= length:
				break
			
			v_this = float(value["value"])
			v_pre = float(values[pre]["value"])
			v_next = float(values[next]["value"])
			# 剔除没访问量的APP
			v_list = [v_pre, v_this, v_next]
			if max(v_list) < 80:
				rate = 1
			else:
				# 加1防止除数为0
				rate = v_this / ((v_next + v_pre + 1)/2)
			ratelist.append(rate)

			timeStr = time.strftime("%Y%m%d/%H:%M:%S", time.localtime(int(value["clock"])))
			plotdata.append({"time":timeStr, "value":value["value"]})
		datareq[app] = {}
		datareq[app]["itemid"] = itemid
		datareq[app]["rate"] = ratelist
		datareq[app]["plotdata"] = plotdata
		len_inc = len(list(filter(lambda x: x>2.5, ratelist)))
		len_dec = len(list(filter(lambda x: x<0.2, ratelist)))
		if len_inc > 0 or len_dec >0:
			unexpected[app] = []
			unexpected[app].append(str(len_inc))
			unexpected[app].append(str(len_dec))
		
	for k,v in unexpected.items():
		if not v:
			continue
		file_name = basepath + "plot_req_" + tag + "_" + k + ".plt"
		file = open(file_name, 'w')
		file.close()

		for j in datareq[k]["plotdata"]:
			with open(file_name, 'a+') as f:
				f.write(j["time"] + " " + j["value"] + "\n")
		linewidth = 1
		plotcmd += "\"" + file_name + "\" using 1:2 title \"" + k + " (" + ",".join(v) + ")" + "\" with lines linewidth " + str(linewidth) + ","

plotcmd = "plot " + plotcmd[:-1]
print(plotcmd)
#print(meanlist[:2])
#print(appdata["tv-desktop"]["plotdata"])
