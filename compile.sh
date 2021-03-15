#!/usr/bin/env bash

MAINCLASS=com.example.DemoApplication
VERSION=0.0.1-SNAPSHOT

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

rm -rf target
mkdir -p target/native-image

echo "Building native image $ARTIFACT with Maven"
./mvnw -Pnative-image package

if [[ -f "target/com.example.demoapplication" ]]
then
  printf "${GREEN}SUCCESS${NC}\n"
  mv target/com.example.demoapplication target/function/spring-native-image
  exit 0
else
  printf "${RED}FAILURE${NC}: an error occurred when compiling the native-image.\n"
  exit 1
fi

