#! /bin/bash

dir=$(pwd)
for file in ${dir}/*.sh; do
    echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  \033[31m${file}\033[0m"
    chmod u+x ${file}
done
