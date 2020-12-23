#!/bin/bash


function ParseConfigurationFile(){
    filename=$(pwd)/Linux.conf
    test ! -f ${filename} && \
        echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error  配置文件 ${filename} 不存在!\033[0m]" && exit 127
    #得到区块数组
    rootArray=(`sed -n '/\[*\]/p' ${filename} |grep -v '^#'|tr -d []`)
    echo ${rootArray[@]}
    #sed -n '/\[*\]/p' 得到包含[*]的行
    #grep -v '^#' 去掉#打头的行
    #tr -d [] 去掉[]
    for ((i=0;i<${#rootArray[@]};i++))
    do
        echo "解析No: "$i
        rootIndex=${rootArray[i]}
        indexNames=(`sed -n '/\['${rootIndex}'\]/,/\[/p' ${filename}|grep -Ev '\[|\]|^$|^#'|awk -F '=' '{print $1}'`)
        #sed -n '/\['$sec_name'\]/,/\[/p' 得到从[$sec_name]到临近[的所有行
        #grep -Ev '\[|\]|^$|^#' 去掉包含[或]的行 去掉空行 去掉#打头的行
        #awk -F '=' '{print $1}'`得到=号前面字符
        indexValues=(`sed -n '/\['${rootIndex}'\]/,/\[/p' ${filename}|grep -Ev '\[|\]|^$|^#'|awk -F '=' '{print $2}'`)
        #awk -F '=' '{print $1}'`得到=号后面字符
        for ((j=0;j<${#indexNames[@]};j++))
        do
            echo ${indexNames[$j]}" "${indexValues[$j]}
        done

    done
}
ParseConfigurationFile