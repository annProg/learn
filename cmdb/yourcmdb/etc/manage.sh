#!/bin/bash
 
#-----------------------------------------------------------
# Usage: 
# $Id: manage.sh  me@annhe.net  2015-10-08 09:37:59 $
#-----------------------------------------------------------

CONFDIR="objecttypes"
CONFFILE="objecttype-configuration.xml"

echo > $CONFFILE
cat > $CONFFILE <<EOF
<object-types>
EOF

for id in `find $CONFDIR -name "*.xml"`;do
	cat >> $CONFFILE <<EOF
	<includeconfig file="$id" />
EOF
done

cat >> $CONFFILE <<EOF
</object-types>
EOF
 
