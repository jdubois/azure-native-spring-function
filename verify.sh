#!/usr/bin/env bash
RESPONSE=`curl -s localhost:8080/ -d '{"name": "World"}'`
if [[ "$RESPONSE" == '{\n  "message": "Hello, World!\n"\n}' ]]; then
  exit 0
else
  exit 1
fi
