#!/usr/bin/env python3
# -*- coding:utf-8 -*-

#-----------------------------------------------------------
# Usage: prompt
# $Id: prompt-exp14.py  i@annhe.net  2015-07-27 00:26:27 $
#-----------------------------------------------------------

import sys

script, user_name = sys.argv
prompt = '> '

"""
多个arguments需要 % (arg1, arg2)
Traceback (most recent call last):
  File "./prompt-exp14.py", line 14, in <module>
    print("Hi %s, I'm the %s script." % user_name, script)
TypeError: not enough arguments for format string
"""
print("Hi %s, I'm the %s script." % (user_name, script))
print("I'd like to ask you a few questions.")
print("Do you like me %s?" % user_name)
likes = input(prompt)

print("Where do you live %s?" % user_name)
lives = input(prompt)

print("What kind of computer do you have?")
computer = input(prompt)

print("""
Alright, so you said %r about liking me.
You live in %r. Not sure where that is.
And you have a %r computer. Nice.
""" % (likes, lives, computer))
