#!/bin/bash
setenforce 0  #
yum install epel-release vim unzip git -y  #
yum upgrade -y
yum install java-21-openjdk -y
