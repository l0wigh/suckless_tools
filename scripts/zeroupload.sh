#!/bin/sh

if [[ $# != 0 ]]
then
	curl -X POST https://0x0.st -F file=@$1
else
	echo "Usage: zeroupload <file>"
fi
