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
	echo -e "\033[34m**      10.修改分辨率:Advanced Options->Resolution->根据需要设置分辨率->确定                       **\033[0m"
	echo -e "\033[34m**                                                                                                 **\033[0m"
	echo -e "\033[34m**                                                                                                 **\033[0m"
	echo -e "\033[34m**                                                                                                 **\033[0m"
	echo -e "\033[34m*****************************************************************************************************\033[0m"
	echo
	echo
	echo
}

#设置静态IP
function Set_Static_IP()
{
    filename=${ConfigArray[staticIPpath]}
    test ! -f ${filename} && \
        Log -E "${filename} 文件不存在!" &&  exit 90
	case "${systemName}" in
		Raspbian)		
			Judge_Txt "^interface.*" "interface ${ConfigArray[staticIPmode]}"
			Judge_Txt "^static ip_address.*" "static ip_address=${ConfigArray[ip_address]}"
			Judge_Txt "^static routers.*" "static routers=${ConfigArray[routers]}"
			Judge_Txt "^static domain_name_servers.*" "static domain_name_servers=${ConfigArray[domain_name_servers]}"	
		;;
		Ubuntu)
			Log -D "调试中。。。。。。"
		;;
		CentOS)
			Log -D "调试中。。。。。。"
		;;
		*)
			Log -E "未知系统!"
		;;
	esac
	Log -I "Set_Static_IP() 函数执行完成!"
	echo
}
function Raspbian_Config(){
	#第1步:开启vncserver,需要注意如下几点:
	#需要注意的是:此服务在raspi-config 中设置好后默认是启动(若服务未启动，可以重启系统)，无需再手动启动，若默认启动失败，则可以手动启动
	#需要注意的是:此服务可以启动多次，因此关闭此服务命令为:vncserver -kill :1
	#-kill :1  	后面的1对应的是手动启动的ID,系统自启动的是没有具体ID的，因此无法使用命令:vncserver -kill :1 停止vncserver服务
	#系统启动的vncserver服务可以使用命令查看具体进程:ps -ef | grep vncserver;如果不清楚注释可以使用此命令查看手动启动服务和系统启动区别
	#此步骤执行目录为:/usr/bin/vncserver ;使用命令vncserver或者/usr/bin/vncserver都可以启动服务vncserver
	#vncserver 
	#第2步:设置界面相关选项
	#sudo raspi-config
	#第3步:更改Pi用户密码,如果密码为原始密码或者最后修改密码时间距离现在日期大于30天,则需要修改密码
	test $(($(($(date --utc --date "$1" +%s)/86400))-$(sudo cat /etc/shadow | grep pi | cut -d ":" -f 3))) -ge 31 &&
		echo -e ${INFOTime}"\033[34m请输入新的Pi账户密码!\033[0m" && \
		sudo passwd pi
	#第4步:设置静态IP地址(此步骤需要提前获取局域网IP相关信息)
	Set_Static_IP
	#Log -D "输出正常"
}
function Ubuntu_Config(){
	#设置为no，更改默认dash为bash
	sudo dpkg-reconfigure dash
	#根据引导程序配置文件判断出电脑系统类型，并判定是否需要修改配置文件
	#GRUB2 开机界面配置文件,去掉不必要的开机选项
	filename=${ConfigArray[grubcfgpath]}
    test ! -f ${filename} && \
        Log -E "${filename} 文件不存在!" &&  exit 90
	local startLine=$(grep -n -E "^### BEGIN /etc/grub.d/20_memtest86\+ ###" ${filename} | cut -d ":" -f1)
	local endLine=$(grep -n -E "^### END /etc/grub.d/20_memtest86\+ ###" ${filename} | cut -d ":" -f1)
	test -z "${startLine}" -o -z "${endLine}" && startLine=0 && endLine=0
	test $((${endLine}-${startLine})) -gt 5 &&  \
		sudo sed -i -e "$((${startLine}+1)),$((${endLine}-1)) d" ${filename} && \
		Log -I "### BEGIN /etc/grub.d/20_memtest86+ ### 文本处理成功!"
	startLine=$(grep -n -E "^submenu 'Advanced options for Ubuntu'" ${filename} | cut -d ":" -f1)
	endLine=$(grep -n -E "^### END /etc/grub.d/10_linux ###" ${filename} | cut -d ":" -f1)
	test -z "${startLine}" -o -z "${endLine}" && startLine=0 && endLine=0
	test $((${endLine}-${startLine})) -gt 5 &&  \
		sudo sed -i -e "${startLine},$((${endLine}-1)) d" ${filename} && \
		Log -I "### BEGIN /etc/grub.d/10_linux ### 文本处理成功!"
	startLine=$(grep -n -E "^### BEGIN /etc/grub.d/30_os-prober ###" ${filename} | cut -d ":" -f1)
	endLine=$(grep -n -E "^### END /etc/grub.d/30_os-prober ###" ${filename} | cut -d ":" -f1)
	test -z "${startLine}" -o -z "${endLine}" && startLine=0 && endLine=0
	test $((${endLine}-${startLine})) -gt 5 &&  \
		filename=${ConfigArray[grubpath]} && \
    	test -f ${filename} && \
			#设置进入GRUB选择界面后默认等待时间5S
			Judge_Txt "^GRUB_TIMEOUT.*" "GRUB_TIMEOUT=5" && \
			#设置默认选择系统选项Windows
			Judge_Txt "^GRUB_DEFAULT.*" "GRUB_DEFAULT=1" && \
			Log -I "### BEGIN /etc/grub.d/30_os-prober ### 文本处理成功!"
	test ! -f ${filename} && \
        Log -E "${filename} 文件不存在!" &&  exit 90
	#设置不提醒系统错误
	filename=${ConfigArray[apportpath]}
    test ! -f ${filename} && \
		Log -E "${filename} 文件不存在!" &&  exit 90
	Judge_Txt "^enabled.*" "enabled=0"
	Log -I "设置不提示系统错误信息成功!"	
	#设置禁止访客登陆
	filename=${ConfigArray[guestpath]}
    test ! -f ${filename} && \
		Log -E "${filename} 文件不存在!" &&  exit 90
	Judge_Txt "^allow-guest.*" "allow-guest=false"
	Log -I "设置禁止访客登陆成功!"
	#设置静态IP
	Set_Static_IP
}
function CentOS_Config(){
	Log -D "CentOS_Config() 函数调试中。。。。。。。。"
}
function Default_Config(){
    test -z "${systemName}" -o  ${systemVersion} -eq 0 && \
        echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""\033[31m系统信息未获取成功!\033[0m" &&  exit 127	
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
Default_Config