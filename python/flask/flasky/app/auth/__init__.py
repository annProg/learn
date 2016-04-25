#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: __init__.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-04-25 10:58:50
############################

from flask import Blueprint

auth = Blueprint('auth', __name__)

from . import views
