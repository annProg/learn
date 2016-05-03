#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: views.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-04-25 11:00:40
############################

from flask import render_template, redirect, request, url_for, flash
from flask.ext.login import login_user, logout_user, login_required, current_user
from . import auth
from ..models import User
from .forms import LoginForm, RegistrationForm
from .. import db
from ..email import send_mail

@auth.before_app_request
def before_app_request():
	if current_user.is_authenticated \
			and not current_user.confirmed \
			and request.endpoint[:5] != 'auth.' \
			and request.endpoint != 'static':
		return redirect(url_for('auth.unconfirmed'))

@auth.route('/unconfirmed')
def unconfirmed():
	if current_user.is_anonymous or current_user.confirmed:
		return redirect(url_for('main.index'))
	return render_template('auth/unconfirmed.html')

@auth.route('/confirm')
@login_required
def resend_confirmation():
	token = current_user.generate_confirmation_token()
	send_mail(current_user.email, '激活邮件', 'auth/email/confirm', user=current_user, token=token)
	flash('激活邮件已重新发送')
	return redirect(url_for('main.index'))

@auth.route('/login', methods=['GET', 'POST'])
def login():
	form = LoginForm()
	if form.validate_on_submit():
		user = User.query.filter_by(email=form.email.data).first()
		if user is not None and user.verify_password(form.password.data):
			login_user(user, form.remember_me.data)
			return redirect(request.args.get('next') or url_for('main.index'))
		flash('用户名或密码错误')
	return render_template('auth/login.html', form=form)

@auth.route('/logout')
@login_required
def logout():
	logout_user()
	flash('退出成功')
	return redirect(url_for('main.index'))

@auth.route('/register', methods=['GET', 'POST'])
def register():
	form = RegistrationForm()
	if form.validate_on_submit():
		user = User(email=form.email.data, username=form.username.data, password=form.password.data)
		db.session.add(user)
		db.session.commit()

		token = user.generate_confirmation_token()
		send_mail(user.email, '邮件激活', 'auth/email/confirm', user=user, token=token)
		flash('激活邮件已发送到您的邮箱，请点击邮件中的链接激活您的账号')
		return redirect(url_for('auth.login'))
	return render_template('auth/register.html', form=form)


@auth.route('/confirm/<token>')
@login_required
def confirm(token):
	if current_user.confirmed:
		return redirect(url_for('main.index'))
	if current_user.confirm(token):
		flash('账号已激活，感谢您的注册')
	else:
		flash('激活失败。链接错误或者失效')
	return redirect(url_for('main.index'))
