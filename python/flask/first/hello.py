#!/usr/bin/env python3
# -*- coding:utf-8 -*-

#-----------------------------------------------------------
# Usage: 一个最小的应用
# $Id: hello.py  i@annhe.net  2015-08-21 22:07:14 $
#-----------------------------------------------------------

from flask import Flask, abort, redirect, url_for
from flask import render_template
app = Flask(__name__)


@app.route('/')
def index():
	return redirect(url_for('login'))

@app.route('/login')
def login():
	abort(401)
	this_is_never_executed()

@app.route('/nginx')
def hello_nginx():
	return 'Nginx'

@app.route('/hean')
def hello_hean():
	return 'Hi! I am hean'

@app.route('/user/<username>')
def show_user_profile(username):
	return 'User %s' % username

@app.route('/post/<int:post_id>')
def show_post(post_id):
	return 'Post %d' % post_id

@app.route('/hello/')
@app.route('/hello/<name>')
def hello(name=None):
	return render_template('hello.html', name=name)
if __name__ == '__main__':
	app.run(host='0.0.0.0', debug=True)
