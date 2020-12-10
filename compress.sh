#!/usr/bin/env bash

ARTIFACT=spring-native-image
MAINCLASS=com.example.demo.DemoApplication
VERSION=0.0.1-SNAPSHOT
UPX_VERSION=3.96
UPX=https://github.com/upx/upx/releases/download/v3.96/upx-3.96-amd64_linux.tar.xz

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "Install UPX"
wget https://github.com/upx/upx/releases/download/v$UPX_VERSION/upx-$UPX_VERSION-amd64_linux.tar.xz
tar -xvf upx-$UPX_VERSION-amd64_linux.tar.xz

echo "Compressing $ARTIFACT with UPX"
./upx-$UPX_VERSION-amd64_linux/upx --best target/function/spring-native-image

echo "Compressing the folder with ZIP"
cd target/function
zip -r -0 ../native_spring_function.zip .
cd ../..
