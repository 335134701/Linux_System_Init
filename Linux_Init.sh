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
		Log -I "当前目录:$(pwd),库文件(Library.sh)存在,程序将开始执行!" && echo
		SystemInformation
		ParseConfigurationFile
	fi
	echo
}
#修改系统源为国内源
function ChangYUM(){ 
    echo
	echo
	Run_SHFile "$(pwd)/Chang_YUM.sh"
    echo
	echo
}
#卸载Ubuntu默认，无用软件
function UnUseSoftware(){
	echo
	echo
    Run_SHFile "$(pwd)/UnUseSoftware.sh"
	echo
	echo
}
#更改默认配置
function DefaultConfig(){
	echo
	echo
    Run_SHFile "$(pwd)/DefaultConfig.sh"
	echo
	echo
}
#安装默认软件
function DefaultSoftware(){
	echo
	echo
    Run_SHFile "$(pwd)/DefaultSoftware.sh"
	echo
	echo
}
#安装第三方软件
function ThirdPartySoftware(){
	echo
	echo
    Run_SHFile "$(pwd)/ThirdPartySoftware.sh"
	echo
	echo
}
function Main()
{
	#Step 1: 校验库文件是否存在
	Check_Library
	#Step 2: 执行欢迎函数
	Welcome
	for((i=0;i<${#ScriptArray[@]};i++)); do
		test ${ScriptArray[i]} != "Library.sh" -a ${ScriptArray[i]} != "${0#*/}"  && \
			Software_Install ${ScriptArray[i]%.*}
			Update_All
			sleep 1s
	done
}
Main