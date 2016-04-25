#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: views.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-04-25 11:00:40
############################

from flask import render_template
from . import auth

@auth.route('login')
def login():
	return render_template('auth/login.html')
