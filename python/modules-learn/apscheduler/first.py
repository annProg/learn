#!/usr/bin/env python
# -*- coding:utf-8 -*-
 
#-----------------------------------------------------------
# Usage: 
# $Id: first.py  me@annhe.net  2015-09-29 11:18:55 $
#-----------------------------------------------------------

from apscheduler.schedulers.blocking import BlockingScheduler
from datetime import datetime
import time
import os
   
def tick():
    print('Tick! The time is: %s' % datetime.now())
 
if __name__ == '__main__':
    scheduler = BlockingScheduler()
    scheduler.add_job(tick,'cron', second='*/3', hour='*')    
    print('Press Ctrl+{0} to exit'.format('Break' if os.name == 'nt' else 'C'))
    try:
        scheduler.start()
    except (KeyboardInterrupt, SystemExit):
        scheduler.shutdown()
