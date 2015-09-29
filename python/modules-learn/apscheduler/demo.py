#!/usr/bin/env python
# -*- coding:utf-8 -*-
 
#-----------------------------------------------------------
# Usage: 
# $Id: demo.py  me@annhe.net  2015-09-29 14:18:11 $
#-----------------------------------------------------------
 
from apscheduler.schedulers.background import BackgroundScheduler
from datetime import datetime
import time, os

def myjob():
	print("Hello : %s" % datetime.now())

sched = BackgroundScheduler()
sched.add_job(myjob, 'interval', seconds=3)
sched.start()

print('Press Ctrl+{0} to exit'.format('Break' if os.name == 'nt' else 'C'))

try:
	# This is here to simulate application activity (which keeps the main thread alive).
	while True:
		time.sleep(2)
except (KeyboardInterrupt, SystemExit):
	scheduler.shutdown()  # Not strictly necessary if daemonic mode is enabled but should be done if possible
