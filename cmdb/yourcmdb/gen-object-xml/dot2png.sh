#!/bin/bash

############################
# Usage:
# File Name: dot2png.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-10-21 14:04:20
############################

./csv2dot.sh
dot -Tpng cmdb.dot -o cmdb.png
dot -Tpng cmdb_gen.dot -o cmdb_gen.png
dot -Tpng cmdb_nosub.dot -o cmdb_nosub.png
