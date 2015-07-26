#!/usr/bin/env python3
# -*- coding:utf-8 -*-

#-----------------------------------------------------------
# Usage: 
# $Id: models.py  i@annhe.net  2015-07-24 23:47:01 $
#-----------------------------------------------------------

from app import db
import datetime

class Todo(db.Document):
	content = db.StringField(required = True, max_length=20)
	time = db.DateTimeField(default = datetime.datetime.now())
	status = db.IntField(default=0)

