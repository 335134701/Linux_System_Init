#! /bin/bash

declare -A ConfigArray
#系统名称
systemName=""
#系统版本号
systemVersion=0

#校验库文件Ubuntu_Library.sh是否存在
function Check_Library()
{
	echo
	if [ ! -f $(pwd)/Library.sh ];then
		echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  当前目录:$(pwd),库文件(Library.sh)不存在,程序无法继续执行!"
		exit 90
	else
        . $(pwd)/Library.sh
		Log -I "当前目录:$(pwd),库文件(Library.sh)存在,程序将开始执行!" && echo
        SystemInformation
        ParseConfigurationFile
	fi
	echo
}
function Main()
{
	#Step 1: 校验库文件是否存在
	Check_Library
    test -z "${systemName}" -o  ${systemVersion} -eq 0 && \
        echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""\033[31m系统信息未获取成功!\033[0m" &&  exit 127
	#Step 2: 执行欢迎函数
	Welcome
	for((i=0;i<${#ScriptArray[@]};i++)); do
		Log -D ${ScriptArray[i]}
		test ${ScriptArray[i]} != "Library.sh" -a ${ScriptArray[i]} != "${0#*/}"  && \
			Software_Install "$(pwd)/${ScriptArray[i]}" && Update_All
			sleep 1s
	done
}

Main