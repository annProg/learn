#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: __init__.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-04-20 19:11:04
############################

from flask import Blueprint

main = Blueprint('main', __name__)

from . import views, errors
