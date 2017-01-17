#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: puzzle.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2017-01-17 14:52:02
############################
import sys

global dot
dot = "[tex=gv,dot]digraph G{\n"

def findSolution(target):
	def find(start, history):
		global dot
		if start == target:
			dot += "\"" + history + "\"[style=\"filled\" fillcolor=\"green\"];"
			dot += 'end[label="结束-右侧分支不会被执行" shape="record"];'
			dot += '"' + history + '" -> end[style="filled", fillcolor="red"];'
			return(history)
		elif start > target:
			dot += "\"" + history + "\"[style=\"filled\" fillcolor=\"yellow\"];"
			return(None)
		else:
			h_a = "(" + history + "%2B5)"
			h_b = "(" + history + "*3)"

			dot += "\"" + history + "\" -> \"" + h_a + "\";\n"
			dot += "\"" + history + "\" -> \"" + h_b + "\";\n"

			a = find(start + 5, h_a)
			b = find(start * 3, h_b)
			
			if a:
				dot += "\"" + history + "\" -> \"" + h_a + "\"[color=\"red\"];\n"
			elif b:
				dot += "\"" + history + "\" -> \"" + h_b + "\"[color=\"red\"];\n"

			return(a or b)
	return(find(1, "1"))

if __name__ == '__main__':
	solution = findSolution(int(sys.argv[1]))
	dot += "}[/tex]"
	print(dot)
	print(solution)
