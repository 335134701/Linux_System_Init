#! /bin/bash

#系统目录
#rootDir=/home/pi/Linux/Linux_System_Init
rootDir=$(pwd)
#库文件路径
LibraryPATH=${rootDir}/Library.sh
#配置文件路径
ConfigPATH=${rootDir}/Linux.conf
#被其他主程序调用标记
transfer=0

#校验库文件Library.sh是否存在
function Check_Library()
{
	echo
	if [ ! -f ${LibraryPATH} ];then
		echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  库文件: ${LibraryPATH} 不存在,程序无法继续执行!"
		exit 90
	else
        . ${LibraryPATH}
		Log -I "库文件: ${LibraryPATH} 存在,程序将开始执行!" && echo
        SystemInformation
        ParseConfigurationFile
	fi
	echo
}

function RUN_Chmod()
{
    dir=$(pwd)
    for file in ${dir}/*.sh; do
        #echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  \033[31m${file}\033[0m"
        Log -I "${file} 添加可执行权限!"
        chmod u+x ${file}
    done
}

function Main()
{
	if [ ${transfer} -eq 0 ]; then
		#Step 1: 校验库文件是否存在
		declare -A ConfigArray
		#系统名称
		systemName=""
		#系统版本号
		systemVersion=0
		Check_Library
        test -z "${systemName}" -o  ${systemVersion} -eq 0 && \
            echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""\033[31m系统信息未获取成功!\033[0m" &&  exit 127
		#Step 2: 执行欢迎函数
		Welcome
	fi
    #Step 3: 执行逻辑处理函数
    RUN_Chmod
}
#如果被其他主要脚本调用，则不需要执行库文件和欢迎脚本
if [ -n "${1}" -a "${1}" == "TRANSFER" ]; then
	transfer=1
fi
Main

