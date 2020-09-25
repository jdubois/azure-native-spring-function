#!/usr/bin/env bash
# Install GraalVM CE

mkdir /home/vsonline/graalvm
cd /home/vsonline/graalvm

export GRAALVM_VERSION=20.2.0
wget -c https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-java11-linux-amd64-${GRAALVM_VERSION}.tar.gz -O - | tar -xz
sudo mv graalvm-ce-java11-${GRAALVM_VERSION}/ /usr/lib/jvm/
cd /usr/lib/jvm
sudo ln -s graalvm-ce-java11-${GRAALVM_VERSION} graalvm
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/graalvm/bin/java 2
/usr/lib/jvm/graalvm/bin/gu install native-image
echo 'export PATH=$PATH:/usr/lib/jvm/graalvm/bin/' >> ~/.bashrc 
