#!/usr/bin/env python3
# -*- coding:utf-8 -*-

#-----------------------------------------------------------
# Usage: 
# $Id: tests/NAME_tests.py  i@annhe.net  2015-07-27 22:14:50 $
#-----------------------------------------------------------

from nose.tools import *
from ex47.game import Room

def test_room():
	gold = Room("GoldRoom","""This room""")
	assert_equal(gold.name, "GoldRoom")
	assert_equal(gold.paths, {})

def test_room_paths():
	center = Room("Center", "Test room in the center.")
	north = Room("North", "Test room in the north.")
	south = Room("South", "Test room in the south.")

	center.add_paths({'north': north, 'south': south})
	assert_equal(center.go('north'), north)	
	assert_equal(center.go('south'), south)	

def test_map():
	start = Room("Start", "You can go west and down .")
	west = Room("Trees", "There are trees.")
	down = Room("Dungeon", "It's a dark down here.")

	start.add_paths({'west': west, 'down': down})
	west.add_paths({'east': start})
	down.add_paths({'up': start})

	assert_equal(start.go('west'), west)
	assert_equal(start.go('west').go('east'), start)
	assert_equal(start.go('down').go('up'), start)
