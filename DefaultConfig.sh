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
	echo -e "\033[34m**      10.修改分辨率:Advanced Options->Resolution->根据需要设置分辨率->确定                     **\033[0m"
	echo -e "\033[34m**                                                                                                 **\033[0m"
	echo -e "\033[34m**                                                                                                 **\033[0m"
	echo -e "\033[34m**                                                                                                 **\033[0m"
	echo -e "\033[34m*****************************************************************************************************\033[0m"
	echo
	echo
	echo
}

#设置静态IP
:<<!
function Raspbian_Set_Static_IP()
{
    filename=/etc/dhcpcd.conf
	read -t 10 -p "请选择设置无线静态IP或有线静态IP(E:有线;W:无线;默认无线): " isChoose
	if [ ${isChoose} = "E" -o ${isChoose} = "e" ];then
		echo -e ${INFOTime}"\033[34m你的输入是:${isChoose},根据你的选择,将设置有线静态IP!\033[0m"
        Judge_Txt "#interface eth0" "interface eth0"
	elif [ ${isChoose} = "W" -o ${isChoose} = "w" ];then
		echo -e ${INFOTime}"\033[34m34m你的输入是:${isChoose},根据你的选择,将设置无线静态IP!\033[0m"
        Judge_Txt "interface wlan0"
	else
		echo -e ${WARNTime}"\033[33m34m你的输入是:${isChoose},输入错误,系统将默认设置有线静态IP!\033[0m"
        Judge_Txt "#interface eth0" "interface eth0"
	fi
    Judge_Txt "static ip_address=192.168.0.150\/24"
	Judge_Txt "static routers=192.168.0.1"
	Judge_Txt "static domain_name_servers=114.114.114.114 8.8.8.8"
}
!
function Raspbian_Config(){
	#第1步:开启vncserver
	vncserver
	#第2步:设置界面相关选项
	#sudo raspi-config
	#第3步:更改Pi用户密码
	echo -e ${INFOTime}"\033[34m请输入新的Pi账户密码!\033[0m"
	sudo passwd pi
	#第4步:设置静态IP地址(此步骤需要提前获取局域网IP相关信息)
	read -p "请确认是否准备好配置静态IP(Y/N):" isChoose
	if [ ${isChoose} = "Y"  -o ${isChoose} = "y" ]; then
		Log -D "输出正常"
	else
		Log -W "未获取局域网IP信息,程序将跳过静态IP设置选项!"
	fi
	#Raspbian_Set_Static_IP
}
function Ubuntu_Config(){
	#设置为no，更改默认dash为bash
	sudo dpkg-reconfigure dash
	#根据引导程序配置文件判断出电脑系统类型，并判定是否需要修改配置文件
	#GRUB2 开机界面配置文件,去掉不必要的开机选项
	fileName=/boot/grub/grub.cfg
	if [ -f "${fileName}" ]; then
		local startLine=$(grep -n -E "^### BEGIN /etc/grub.d/20_memtest86\+ ###" ${fileName} | cut -d ":" -f1)
		local endLine=$(grep -n -E "^### END /etc/grub.d/20_memtest86\+ ###" ${fileName} | cut -d ":" -f1)
		test -z "${startLine}" -o -z "${endLine}" && startLine=0 && endLine=0
		test $((${endLine}-${startLine})) -gt 5 &&  \
			sudo sed -i -e "$((${startLine}+1)),$((${endLine}-1)) d" ${fileName} && \
			Log -I "### BEGIN /etc/grub.d/20_memtest86+ ### 文本处理成功!"
		startLine=$(grep -n -E "^submenu 'Advanced options for Ubuntu'" ${fileName} | cut -d ":" -f1)
		endLine=$(grep -n -E "^### END /etc/grub.d/10_linux ###" ${fileName} | cut -d ":" -f1)
		test -z "${startLine}" -o -z "${endLine}" && startLine=0 && endLine=0
		test $((${endLine}-${startLine})) -gt 5 &&  \
			sudo sed -i -e "${startLine},$((${endLine}-1)) d" ${fileName} && \
			Log -I "### BEGIN /etc/grub.d/10_linux ### 文本处理成功!"
		startLine=$(grep -n -E "^### BEGIN /etc/grub.d/30_os-prober ###" ${fileName} | cut -d ":" -f1)
		endLine=$(grep -n -E "^### END /etc/grub.d/30_os-prober ###" ${fileName} | cut -d ":" -f1)
		test -z "${startLine}" -o -z "${endLine}" && startLine=0 && endLine=0
		test $((${endLine}-${startLine})) -gt 5 &&  \
			fileName=/etc/default/grub && \
			#设置进入GRUB选择界面后默认等待时间5S
			sudo sed -i -e 's/'"^GRUB_TIMEOUT.*/GRUB_TIMEOUT=5"'/g' ${fileName}   && \
			#设置默认选择系统选项Windows
			sudo sed -i -e 's/'"^GRUB_DEFAULT.*/GRUB_DEFAULT=1"'/g' ${fileName} && \
			Log -I "### BEGIN /etc/grub.d/30_os-prober ### 文本处理成功!"
	else
		Log -E "${fileName} 文件不存在!"
	fi
	#设置不提醒系统错误
	fileName=/etc/default/apport
	if [ -f "${fileName}" ];then
		test -z $(grep -n -E "^enabled=0" ${fileName}) && \
			sudo sed -i 's/'"^enabled.*/enabled=0"'/g' ${fileName} && \
			Log -I "设置不提示系统错误信息成功!"
	else  
		Log -E "${fileName} 文件不存在!"
	fi	
	#设置禁止访客登陆
	fileName=/usr/share/lightdm/lightdm.conf.d/50-guest-wrapper.conf
	if [ -f "${fileName}" ];then
		test -z $(grep -n -E "^allow-guest.*" ${fileName}) && \
			sudo sed -i \$a"allow-guest=false"  ${fileName}  && \
			Log -I "设置禁止访客登陆成功!"
	else
		Log -E "${fileName} 文件不存在!"
	fi
}
function CentOS_Config(){
	Log -D "CentOS_Config() 函数调试中。。。。。。。。"
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