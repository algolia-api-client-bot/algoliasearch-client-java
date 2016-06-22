#!/bin/sh
mvn -Darguments="-DskipTests" release:prepare
mvn -Darguments="-DskipTests" release:perform

REP_ID=`mvn nexus-staging:rc-list | grep comalgolia | cut -d" " -f2`

if [ -z "$REP_ID" ]; then
	# Retrying
	REP_ID=`mvn nexus-staging:rc-list | grep comalgolia | cut -d" " -f1`
fi

if [ -z "$REP_ID" ]; then
	echo "Can not find a REP_ID"
	exit 1
fi

echo "REP_ID found: $REP_ID"

mvn nexus-staging:close -DstagingRepositoryId="$REP_ID"
mvn nexus-staging:release -DstagingRepositoryId="$REP_ID"