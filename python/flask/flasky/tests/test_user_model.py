#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: test_user_model.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-04-21 17:24:57
############################

import unittest
from app.models import User

class UserModelTestCase(unittest.TestCase):
	def test_password_setter(self):
		u = User(password = 'cat')
		self.assertTrue(u.password_hash is not None)
	
	def test_no_password_getter(self):
		u = User(password = 'cat')
		with self.assertRaises(AttributeError):
			u.password
	
	def test_password_verification(self):
		u = User(password = 'cat')
		self.assertTrue(u.verify_password('cat'))
		self.assertFalse(u.verify_password('dog'))

	def test_password_salts_are_random(self):
		u = User(password = 'cat')
		u2 = User(password = 'dog')
		self.assertTrue(u.password_hash != u2.password_hash)
