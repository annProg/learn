#!/usr/bin/env python
# -*- coding:utf-8 -*-
 
#-----------------------------------------------------------
# Usage: 
# $Id: background.py  me@annhe.net  2015-09-29 14:16:48 $
#-----------------------------------------------------------
 
from datetime import datetime
import time
import os

from apscheduler.schedulers.background import BackgroundScheduler


def tick():
    print('Tick! The time is: %s' % datetime.now())


if __name__ == '__main__':
    scheduler = BackgroundScheduler()
    scheduler.add_job(tick, 'interval', seconds=3)
    scheduler.start()
    print('Press Ctrl+{0} to exit'.format('Break' if os.name == 'nt' else 'C'))

    try:
        # This is here to simulate application activity (which keeps the main thread alive).
        while True:
            time.sleep(2)
    except (KeyboardInterrupt, SystemExit):
        scheduler.shutdown()  # Not strictly necessary if daemonic mode is enabled but should be done if possible

