#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: errors.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-04-20 19:16:52
############################

from flask import render_template
from . import main

@main.app_errorhandler(404)
def page_not_found(e):
	return render_template('404.html'), 404

@main.app_errorhandler(500)
def internal_server_error(e):
	return render_template('500.html'), 500
