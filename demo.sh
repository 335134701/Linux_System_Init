#!/bin/bash
cnf=$(pwd)/my.conf

#得到区块数组
g_sec=($(sed -n '/\[*\]/p' $cnf |grep -v '^#'|tr -d []))
echo ${g_sec[*]}
#sed -n '/\[*\]/p' 得到包含[*]的行
#grep -v '^#' 去掉#打头的行
#tr -d [] 去掉[]
#g_sec=(client mysqld mysqld_safe)

for ((i=0;i<${#g_sec[@]};i++))
do
    echo "解析No: "$i
    sec_name=${g_sec[i]}
    g_names=(`sed -n '/\['$sec_name'\]/,/\[/p' $cnf|grep -Ev '\[|\]|^$|^#'|awk -F '=' '{print $1}'`)
    #sed -n '/\['$sec_name'\]/,/\[/p' 得到从[$sec_name]到临近[的所有行
    #grep -Ev '\[|\]|^$|^#' 去掉包含[或]的行 去掉空行 去掉#打头的行
    #awk -F '=' '{print $1}'`得到=号前面字符

    g_values=(`sed -n '/\['$sec_name'\]/,/\[/p' $cnf|grep -Ev '\[|\]|^$|^#'|awk -F '=' '{print $2}'`)
    #awk -F '=' '{print $1}'`得到=号后面字符
    for ((j=0;j<${#g_names[@]};j++))
    do
            echo ${g_names[$j]}" "${g_values[$j]}
    done

done