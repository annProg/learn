#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: views.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-04-20 19:56:33
############################

from flask import render_template, session, redirect, url_for, current_app, flash, request, abort
from .. import db
from ..models import User, Role, Post, Permission
from ..email import send_mail
from . import main
from .forms import EditProfileForm, NameForm, EditProfileAdminForm, PostForm
from flask.ext.login import login_required, current_user
from ..decorators import admin_required, permission_required
import hashlib

@main.route('/', methods=['GET', 'POST'])
def index():
	form = PostForm()
	if current_user.can(Permission.WRITE_ARTICLES) and form.validate_on_submit():
		post = Post(body=form.body.data, author=current_user._get_current_object())
		db.session.add(post)
		db.session.commit()
		return redirect(url_for('.index'))

	page = request.args.get('page', 1, type=int)
	pagination = Post.query.order_by(Post.timestamp.desc()).paginate(page, per_page=current_app.config['FLASKY_POSTS_PER_PAGE'],
			error_out=False)
	posts = pagination.items
	return render_template('index.html', form=form, posts=posts, pagination=pagination)

@main.route('/user/<username>')
def user(username):
	user = User.query.filter_by(username=username).first()
	if user is None:
		abort(404)
	page = request.args.get('page', 1, type=int)
	pagination = user.posts.order_by(Post.timestamp.desc()).paginate(page, per_page=current_app.config['FLASKY_POSTS_PER_PAGE'],
			error_out=False)
	posts = pagination.items
	return render_template('user.html', user=user, posts=posts, pagination=pagination)

@main.route('/edit-profile', methods=['GET', 'POST'])
@login_required
def edit_profile():
	form = EditProfileForm()
	if form.validate_on_submit():
		current_user.name = form.name.data
		current_user.location = form.location.data
		current_user.about_me = form.about_me.data
		db.session.add(current_user)
		db.session.commit()
		flash('个人资料已更新')
		return redirect(url_for('.user', username=current_user.username))
	form.name.data = current_user.name
	form.location.data = current_user.location
	form.about_me.data = current_user.about_me
	return render_template('edit_profile.html', form=form)

@main.route('/secret')
@login_required
def secret():
	return '登录用户可见'

@main.route('/edit-profile/<int:id>', methods=['GET', 'POST'])
@login_required
@admin_required
def edit_profile_admin(id):
	user = User.query.get_or_404(id)
	form = EditProfileAdminForm(user=user)
	if form.validate_on_submit():
		user.email = form.email.data
		user.avatar_hash = hashlib.md5(user.email.encode('utf-8')).hexdigest()
		user.username = form.username.data
		user.confirmed = form.confirmed.data
		user.role = Role.query.get(form.role.data)
		user.name = form.name.data
		user.location = form.location.data
		user.about_me = form.about_me.data
		db.session.add(user)
		flash('The profile has been updated.')
		return redirect(url_for('.user', username=user.username))
	form.email.data = user.email
	form.username.data = user.username
	form.confirmed.data = user.confirmed
	form.role.data = user.role_id
	form.name.data = user.name
	form.location.data = user.location
	form.about_me.data = user.about_me
	return render_template('edit_profile.html', form=form, user=user)


@main.route('/post/<int:id>')
def post(id):
	post = Post.query.get_or_404(id)
	return render_template('post.html', posts=[post])

@main.route('/edit/<int:id>', methods=['GET', 'POST'])
@login_required
def edit(id):
	post = Post.query.get_or_404(id)
	if current_user != post.author and not current_user.can(Permission.ADMINISTER):
		abort(403)
	form = PostForm()
	if form.validate_on_submit():
		post.body = form.body.data
		db.session.add(post)
		db.session.commit()
		flash('文章已更新')
		return redirect(url_for('.post', id=post.id))
	form.body.data = post.body
	return render_template('edit_post.html', form=form)
	

@main.route('/follow/<username>')
@login_required
@permission_required(Permission.FOLLOW)
def follow(username):
	user = User.query.filter_by(username=username).first()
	if user is None:
		flash('无此用户')
		return redirect(url_for('.index'))
	if current_user.is_following(user):
		flash('已关注此用户')
		return redirect(url_for('.user', username=username))
	current_user.follow(user)
	flash('您已关注 %s' % username)
	return redirect(url_for('.user', username=username))

@main.route('/unfollow/<username>')
@login_required
@permission_required(Permission.FOLLOW)
def unfollow(username):
	user = User.query.filter_by(username=username).first()
	if user is None:
		flash('无此用户')
		return redirect(url_for('.index'))
	if not current_user.is_following(user):
		flash('您未关注此用户')
		return redirect(url_for('.user', username=username))
	current_user.unfollow(user)
	flash('已取消关注 %s' % username)
	return redirect(url_for('.user', username=username))

@main.route('/followers/<username>')
def followers(username):
	user = User.query.filter_by(username=username).first()
	if user is None:
		flash('Invalid user.')
		return redirect(url_for('.index'))
	page = request.args.get('page', 1, type=int)
	pagination = user.followers.paginate(
		page, per_page=current_app.config['FLASKY_FOLLOWERS_PER_PAGE'],
		error_out=False)
	follows = [{'user': item.follower, 'timestamp': item.timestamp}
			   for item in pagination.items]
	return render_template('followers.html', user=user, title="Followers of",
						   endpoint='.followers', pagination=pagination,
						   follows=follows)


@main.route('/followed-by/<username>')
def followed_by(username):
	user = User.query.filter_by(username=username).first()
	if user is None:
		flash('Invalid user.')
		return redirect(url_for('.index'))
	page = request.args.get('page', 1, type=int)
	pagination = user.followed.paginate(
		page, per_page=current_app.config['FLASKY_FOLLOWERS_PER_PAGE'],
		error_out=False)
	follows = [{'user': item.followed, 'timestamp': item.timestamp}
			   for item in pagination.items]
	return render_template('followers.html', user=user, title="Followed by",
						   endpoint='.followed_by', pagination=pagination,
						   follows=follows)
