#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: forms.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-04-27 11:13:47
############################

from flask.ext.wtf import Form
from wtforms import StringField, PasswordField, BooleanField, SubmitField
from wtforms.validators import Required, Length, Email, Regexp, EqualTo
from wtforms import ValidationError
from ..models import User

class LoginForm(Form):
	email = StringField('邮箱', validators=[Required(), Length(1,64), Email()])
	password = PasswordField('密码', validators=[Required()])
	remember_me = BooleanField('记住我')
	submit = SubmitField('登录')

class RegistrationForm(Form):
	email = StringField('邮箱', validators=[Required(), Length(1, 64), Email()])
	username = StringField('用户名', validators=[Required(), Length(1, 64), Regexp('^[A-Za-z0-9_.]*$', 0, '只能包含字母数字下划线及点')])
	password = PasswordField('密码', validators=[Required(), EqualTo('password2', message='两次输入密码必须一致')])
	password2 = PasswordField('确认密码', validators=[Required()])
	submit = SubmitField('注册')

	def validate_email(self, field):
		if User.query.filter_by(email=field.data).first():
			raise ValidationError('此邮箱已被注册, 请直接登录')
	
	def validate_username(self, field):
		if User.query.filter_by(username=field.data).first():
			raise ValidationError('此用户名已被占用')
