#! /bin/bash

dir=$(pwd)
for file in ${dir}/*.sh; do
    echo ${file}
    chmod 755 ${file}
done
