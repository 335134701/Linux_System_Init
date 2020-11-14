#! /bin/bash

#校验库文件Ubuntu_Library.sh是否存在
function Check_Library()
{
	echo
	if [ ! -f $(pwd)/Library.sh ];then
		echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  当前目录:$(pwd),库文件(Library.sh)不存在,程序无法继续执行!"
		exit 90
	else
        . Library.sh
		Log -I "当前目录:$(pwd),库文件(Library.sh)存在,程序将开始执行!"
	fi
	echo
}
#修改系统源为国内源
function Change_YUM(){ 
    echo
	echo
	Run_SHFile "$(pwd)/Chang_YUM.sh"
    echo
	echo
}
#卸载Ubuntu默认，无用软件
function Remove_Unusing_Software(){
	echo
	echo
    Run_SHFile "$(pwd)/UnUseSoftware.sh"
	echo
	echo
}
#更改默认配置
function Default_Configuration(){
	echo
	echo
    Run_SHFile "$(pwd)/DefaultConfig.sh"
	echo
	echo
}
#安装默认软件
function Default_Configuration(){
	echo
	echo
    Run_SHFile "$(pwd)/DefaultSoftware.sh.sh"
	echo
	echo
}
function Main()
{
	#Step 1: 校验库文件是否存在
	Check_Library
	#Step 2: 执行欢迎函数
	Welcome
    #如果是树莓派系统，另需要说明一下其他相关操作
    if [ ${systemName} = "Raspbian" ]; then
        Description_Init_Desktop
    fi
	sleep 1s
    #Step 3:获取系统信息
    SystemInformation
	#Step 4:更换YUM
	Software_Install "Change_YUM"
    #Step 5:更换YUM
    Update_All
	sleep 2s
	#Step 6:执行卸载Ubuntu自带软件函数
	#Software_Install "Remove_Unusing_Software"
}
Main