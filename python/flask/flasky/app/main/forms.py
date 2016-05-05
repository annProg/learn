#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: forms.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-04-21 15:06:41
############################

from flask.ext.wtf import Form
from flask.ext.pagedown.fields import PageDownField
from wtforms import StringField, TextAreaField, SubmitField, BooleanField, SelectField
from wtforms.validators import Required, Length, Email, Regexp
from wtforms import ValidationError
from ..models import Role, User


class NameForm(Form):
    name = StringField('What is your name?', validators=[Required()])
    submit = SubmitField('Submit')

class EditProfileForm(Form):
	name = StringField('姓名', validators=[Length(0, 64)])
	location = StringField('位置', validators=[Length(0, 64)])
	about_me = TextAreaField('自我介绍')
	submit = SubmitField('更新')

class EditProfileAdminForm(Form):
	email = StringField('邮箱', validators=[Required(), Length(1, 64), Email()])
	username = StringField('用户名', validators=[Required(), Length(1,64), Regexp('^[A-za-z0-9_.]*$',0,'用户名包含非法字符')])
	confirmed = BooleanField('验证状态')
	role = SelectField('Role', coerce=int)
	name = StringField('姓名', validators=[Length(0,64)])
	location = StringField('位置', validators=[Length(0,64)])
	about_me = TextAreaField('自我介绍')
	submit = SubmitField('更新')

	def __init__(self, user, *args, **kwargs):
		super(EditProfileAdminForm, self).__init__(*args, **kwargs)
		self.role.choices = [(role.id, role.name) for role in Role.query.order_by(Role.name).all()]
		self.user = user

	def validate_email(self, field):
		if field.data != self.user.email and \
				User.query.filter_by(email=field.data).first():
			raise ValidationError('邮箱已被占用')
	
	def validate_username(self, field):
		if field.data != self.user.username and \
				User.query.filter_by(username=field.data).first():
			raise ValidationError('用户名已被占用')

class PostForm(Form):
	body = PageDownField('写下您的想法', validators=[Required()])
	submit = SubmitField('提交')
