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
#树莓派安装第三方应用软件
function Raspbian_ThirdPart_Software()
{
    Log -D "Raspbian_ThirdPart_Software() 函数调试中。。。。。。。。"
}
#Ubuntu安装第三方应用软件
function Ubuntu_ThirdPart_Software()
{
    Log -D "Ubuntu_ThirdPart_Software() 函数调试中。。。。。。。。"
}
#CentOS安装第三方应用软件
function CentOS_ThirdPart_Software()
{
    Log -D "CentOS_ThirdPart_Software() 函数调试中。。。。。。。。"
}

#以下函数还可以进行优化处理，优化方式是形成函数
#安装第三方应用软件及配置相应环境
function Install_ThirdPart_Software(){
	case "${systemName}" in
		Raspbian)
			Raspbian_ThirdPart_Software
		;;
		Ubuntu)
			Ubuntu_ThirdPart_Software
		;;
		CentOS)
			CentOS_ThirdPart_Software
		;;
		*)
			Log -E "未知系统!"
		;;
	esac
	Log -I "Install_ThirdPart_Software() 方法执行完成!"
}
Check_Library
SystemInformation
Install_ThirdPart_Software