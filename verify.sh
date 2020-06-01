#!/usr/bin/env bash
RESPONSE=`curl -s localhost:1337/ -d world -H "Content-Type: text/plain"`
if [[ "$RESPONSE" == 'Hello, world!' ]]; then
  exit 0
else
  exit 1
fi
