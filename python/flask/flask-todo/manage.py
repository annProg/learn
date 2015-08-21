#!/usr/bin/env python3
# -*- coding:utf-8 -*-

#-----------------------------------------------------------
# Usage: 启动服务器，数据库配置
# $Id: manage.py  i@annhe.net  2015-07-24 23:49:36 $
#-----------------------------------------------------------

from flask.ext.script import Manager, Server
from app import app
from app.models import Todo

manager = Manager(app)

manager.add_command("run", Server(host='0.0.0.0',port=5000,use_debugger=True))

@manager.command
def save_todo():
	todo = Todo(content = "my first todo")
	todo.save()

if __name__ == '__main__':
	manager.run()
