#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name:
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-04-21 14:51:06
############################

from . import db
from werkzeug.security import generate_password_hash, check_password_hash
from flask.ext.login import UserMixin
from . import login_manager
from itsdangerous import TimedJSONWebSignatureSerializer as Serializer
from flask import current_app

class Role(db.Model):
	__tablename__ = 'roles'
	id = db.Column(db.Integer, primary_key = True)
	name = db.Column(db.String(64), unique = True)
	users = db.relationship('User', backref='role')

	def __repr__(self):
		return '<Role %r>' % self.name

class User(UserMixin, db.Model):
	__tablename__ = 'users'
	id = db.Column(db.Integer, primary_key = True)
	email = db.Column(db.String(64), unique=True, index=True)
	username = db.Column(db.String(64), unique = True, index = True)
	password_hash = db.Column(db.String(128))
	role_id = db.Column(db.Integer, db.ForeignKey('roles.id'))
	confirmed = db.Column(db.Boolean, default=False)

	@property
	def password(self):
		raise AttributeError('password is not a readable attribute')

	@password.setter
	def password(self, password):
		self.password_hash = generate_password_hash(password)
	
	def verify_password(self, password):
		return check_password_hash(self.password_hash, password)

	def generate_confirmation_token(self, expiration=300):
		s = Serializer(current_app.config['SECRET_KEY'], expiration)
		return s.dumps({'confirm': self.id})

	def confirm(self, token):
		s = Serializer(current_app.config['SECRET_KEY'])
		try:
			data = s.loads(token)
		except:
			return False

		if data.get('confirm') != self.id:
			return False
		self.confirmed = True
		db.session.add(self)
		db.session.commit()
		return True

	def __repr__(self):
		return '<User %r>' % self.username

@login_manager.user_loader
def load_user(user_id):
	return User.query.get(int(user_id))
