#! /bin/bash

dir=$(pwd)
for file in ${dir}/*.sh; do
    echo ${file}
    chmod u+x ${file}
done
