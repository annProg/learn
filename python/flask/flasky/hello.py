#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: hello.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-04-14 16:03:52
############################

from flask import Flask, render_template, session, redirect, url_for, flash
from flask.ext.script import Manager
from flask.ext.bootstrap import Bootstrap
from flask.ext.moment import Moment
from flask.ext.wtf import Form
from wtforms import StringField, SubmitField
from wtforms.validators import Required
from datetime import datetime
import appconfig

app = Flask(__name__)
manager = Manager(app)
bootstrap = Bootstrap(app)
moment = Moment(app)

app.config['SECRET_KEY'] = appconfig.config['SECRET_KEY']
class NameForm(Form):
	name = StringField('姓名', validators = [Required()])
	submit = SubmitField('提交')

@app.route('/', methods=['GET', 'POST'])
def index():
	form = NameForm()
	if form.validate_on_submit():
		old_name = session.get('name')
		if old_name is not None and old_name != form.name.data:
			flash('似乎您改变了您的用户名!')
		session['name'] = form.name.data
		return redirect(url_for('index'))
	
	return(render_template('index.html', current_time=datetime.utcnow(), form=form, name=session.get('name')))

@app.route('/user/<name>')
def user(name):
	return(render_template('user.html', name=name))

@app.errorhandler(404)
def page_not_found(e):
	return render_template('404.html'),404

@app.errorhandler(500)
def internal_server_error(e):
	return render_template('500.html'),404

if __name__ == '__main__':
	manager.run()
