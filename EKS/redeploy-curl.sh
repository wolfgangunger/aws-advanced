#!/bin/sh
#if [ "$#" -ne 2 ]; then
#	echo "you need to pass 3 parameters!"
#	echo "usage: $0 <host> <port>"
#	exit 1
#fi
#
curl -X POST \
	-k \
	-H 'X-Requested-By: micro' \
	-H 'Authorization: Basic YWRtaW46YWRtaW4=' \
	-F id=@./target/micro-sample.war \
	-F force=true https://localhost:50048/management/domain/applications/application