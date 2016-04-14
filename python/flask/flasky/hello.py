#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: hello.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-04-14 16:03:52
############################

from flask import Flask, render_template
from flask.ext.script import Manager

app = Flask(__name__)
manager = Manager(app)


@app.route('/')
def index():
	return(render_template('index.html'))

@app.route('/user/<name>')
def user(name):
	return(render_template('user.html', name=name))

if __name__ == '__main__':
	manager.run()
