#! /bin/bash

#**********************************************************
#树莓派(Raspbian)系统初始化界面设置相关操作:
	# 1.开启SSH:系统烧录完成后,在SD卡根目录新建SSH文件
	# 2.获取树莓派IP,SSH连接树莓派:User:pi;Passwd:raspberry   
	# 3.输入命令vncserver,可临时远程界面VNC Viewer连接
	# 4.打开vnc viewer,配置:VNC Server: IP:5900/5901; Name:pi
	# 5.连接成功,打开命令行,输入:sudo raspi-config
	# 6.开机自启动SSH:Interfacing Options->SSH->是->Enter键
	# 7.开机自启动VNC:Interfacing Options->VNC->是->Enter键     
	# 8.设置中文环境:Change Locale->选择:zh_CN.GB2312;zh_CN.GB18030;zh_GBK;zh_CN.UTF-8->OK
	#   注意:空格键可选择多选或取消多选
	# 9.若SD卡空间大于树莓派显示空间,可扩展空间:Advanced Options->Al Expand Filesystem->确定
	# 10.修改分辨率:Advanced Options->Resolution->根据需要设置分辨率->确定
#**********************************************************

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
#初始化界面设置相关操作显示
function Raspbian_Description()
{
	echo
	echo
	echo
	echo -e "\033[34m*****************************************************************************************************\033[0m"
	echo -e "\033[34m**                                                                                                 **\033[0m"
	echo -e "\033[34m**                                                                                                 **\033[0m"
	echo -e "\033[34m**                                                                                                 **\033[0m"
	echo -e "\033[34m**  初始化界面设置相关操作:                                                                        **\033[0m"
	echo -e "\033[34m**      1.开启SSH:系统烧录完成后,在SD卡根目录新建SSH文件                                           **\033[0m"
	echo -e "\033[34m**      2.获取树莓派IP,SSH连接树莓派:User:pi;Passwd:raspberry                                      **\033[0m"
	echo -e "\033[34m**      3.输入命令vncserver,可临时远程界面VNC Viewer连接                                           **\033[0m"
	echo -e "\033[34m**      4.打开vnc viewer,配置:VNC Server: IP:5900/5901; Name:pi                                    **\033[0m"
	echo -e "\033[34m**      5.连接成功,打开命令行,输入:sudo raspi-config                                               **\033[0m"
	echo -e "\033[34m**      6.开机自启动SSH:Interfacing Options->SSH->是->Enter键     			           **\033[0m"
	echo -e "\033[34m**      7.开机自启动VNC:Interfacing Options->VNC->是->Enter键                                      **\033[0m"
	echo -e "\033[34m**      8.设置中文环境:Change Locale->选择:zh_CN.GB2312;zh_CN.GB18030;zh_GBK;zh_CN.UTF-8->OK       **\033[0m"
	echo -e "\033[34m**        注意:空格键可选择多选或取消多选                                                          **\033[0m"
	echo -e "\033[34m**      9.若SD卡空间大于树莓派显示空间,可扩展空间:Advanced Options->Al Expand Filesystem->确定     **\033[0m"
	echo -e "\033[34m**      10.修改分辨率:Advanced Options->Resolution->根据需要设置分辨率->确定                     **\033[0m"
	echo -e "\033[34m**                                                                                                 **\033[0m"
	echo -e "\033[34m**                                                                                                 **\033[0m"
	echo -e "\033[34m**                                                                                                 **\033[0m"
	echo -e "\033[34m*****************************************************************************************************\033[0m"
	echo
	echo
	echo
}
function Raspbian_Config(){
	#第1步:开启vncserver
	vncserver
	#第2步:设置界面相关选项
	sudo raspi-config
	#第3步:更改Pi用户密码
	echo -e ${INFOTime}"\033[34m请输入新的Pi账户密码!\033[0m"
	sudo passwd pi
	Log -I "Raspbian_Config() 函数执行完成!"
}
function Ubuntu_Config(){
	#设置为no，更改默认dash为bash
	sudo dpkg-reconfigure dash
	#GRUB2 开机界面配置文件
	fileName=/boot/grub/grub.cfg
	#根据引导程序配置文件判断出电脑系统类型，并判定是否需要修改配置文件
	#设置不提醒系统错误
	fileName='/etc/default/apport'
	Log -I "Ubuntu_Config() 函数执行完成!"
}
function CentOS_Config(){
	Log -I "CentOS_Config() 函数执行完成!"
}
function Default_Config(){
	case "${systemName}" in
		Raspbian)
			Raspbian_Description
			Raspbian_Config
		;;
		Ubuntu)
			Ubuntu_Config
		;;
		CentOS)
			CentOS_Config
		;;
		*)
			Log -E "未知系统!"
		;;
	esac
	Log -I "Default_Config() 函数执行完成!"
}
Check_Library
SystemInformation
Default_Config