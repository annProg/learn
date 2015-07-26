#!/usr/bin/env python3
# -*- coding:utf-8 -*-

#-----------------------------------------------------------
# Usage: 
# $Id: views.py  i@annhe.net  2015-07-24 23:48:35 $
#-----------------------------------------------------------

from app import app
from flask import render_template, request
from app.models import Todo

@app.route('/')
def index():
	todos = Todo.objects.all()
	return render_template("index.html", todos=todos)

@app.route('/add', methods=['Post',])
def add():
	content = request.form.get("content")
	todo = Todo(content=content)
	todo.save()
	todos = Todo.objects.all()
	return render_template("index.html", todos=todos)
