#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: __init__.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-04-14 16:03:52
############################

from flask import Flask, render_template
from flask.ext.bootstrap import Bootstrap
from flask.ext.mail import Mail
from flask.ext.moment import Moment
from flask.ext.sqlalchemy import SQLAlchemy
from config import config


bootstrap = Bootstrap()
moment = Moment()
mail = Mail()
db = SQLAlchemy()

def create_app(config_name):
	app = Flask(__name__)
	app.config.from_object(config[config_name])
	config[config_name].init_app(app)

	bootstrap = Bootstrap(app)
	moment = Moment(app)
	mail = Mail(app)
	db = SQLAlchemy(app)

	from .main import main as main_blueprint
	app.register_blueprint(main_blueprint)

	return app
