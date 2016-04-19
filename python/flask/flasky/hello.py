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
from flask.ext.migrate import Migrate, MigrateCommand
from flask.ext.script import Manager, Shell
from flask.ext.bootstrap import Bootstrap
from flask.ext.moment import Moment
from flask.ext.wtf import Form
from wtforms import StringField, SubmitField
from wtforms.validators import Required
from flask.ext.sqlalchemy import SQLAlchemy
from datetime import datetime
import appconfig
import os

basedir = os.path.abspath(os.path.dirname(__file__))

app = Flask(__name__)
manager = Manager(app)
bootstrap = Bootstrap(app)
moment = Moment(app)

app.config['SECRET_KEY'] = appconfig.config['SECRET_KEY']
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'data.sqlite')
app.config['SQLALCHEMY_COMMIT_ON_TEARDOWN'] = True
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True

db = SQLAlchemy(app)

migrate = Migrate(app,db)
manager.add_command('db', MigrateCommand)

class Role(db.Model):
	__tablename__ = 'roles'
	id = db.Column(db.Integer, primary_key = True)
	name = db.Column(db.String(64), unique = True)
	users = db.relationship('User', backref='role')

	def __repr__(self):
		return '<Role %r>' % self.name

class User(db.Model):
	__tablename__ = 'users'
	id = db.Column(db.Integer, primary_key = True)
	username = db.Column(db.String(64), unique = True, index = True)
	role_id = db.Column(db.Integer, db.ForeignKey('roles.id'))

	def __repr__(self):
		return '<User %r>' % self.username

class NameForm(Form):
	name = StringField('姓名', validators = [Required()])
	submit = SubmitField('提交')

def make_shell_context():
	return dict(app=app,db=db,User=User, Role=Role)
manager.add_command("shell", Shell(make_context=make_shell_context))

@app.route('/', methods=['GET', 'POST'])
def index():
	form = NameForm()
	if form.validate_on_submit():
		user = User.query.filter_by(username=form.name.data).first()
		if user is None:
			user = User(username = form.name.data)
			db.session.add(user)
			session['known'] = False
		else:
			session['known'] = True

		session['name'] = form.name.data
		form.name.data = ''
		return redirect(url_for('index'))
	
	return(render_template('index.html', known = session.get('known', False), form=form, name=session.get('name')))

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
