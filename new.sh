#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Few Argument"
  echo "USAGE: $0 blogs|news|posts"
  exit 1
fi
if [ $1 != "blogs" ] && [ $1 != "posts" ] && [ $1 != "news" ]; then
  echo "Invalid Argument"
  echo "USAGE: $0 blogs|news|posts"
  exit 1
fi

filename=$(date "+%Y-%m-%d-%H%M")/index.md
./hugo new $1/$filename
echo "Congratulations!!"
echo "content/$1/$filename Created!"
echo "Edit and Deploy!"