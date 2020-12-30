#! /bin/bash

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

#树莓派默认软件安装
function Raspbian_Software(){
	#第1步:安装字体库
	Default_Install  "fonts-wqy-zenhei"
	#第2步:安装中文输入法
	Default_Install  "scim-pinyin"
	#第3步:安装vim编辑器
	Default_Install  "vim"
	#第4步:安装gedit编辑器
	Default_Install  "gedit"
	#第5步:安装GCC G++
	Default_Install  "gcc g++"	
	#第6步:安装openssh-server
	Default_Install  "openssh-server"
	#第7步:安装wget下载器
	Default_Install  "wget"
	#第8步:安装tcpdump抓包软件
	Default_Install  "tcpdump"
	#第9步:安装wireshark抓包软件
	Default_Install  "wireshark"
	#第10步:安装cmake编译器
	Default_Install  "cmake"	
}
#Ubuntu默认软件安装
function Ubuntu_Software(){
	#第1步:安装vim编辑器，Ubunutu14 由于vim-common库版本冲突，无法安装vim，需要卸载库再进行安装
	#f附加安装nautilus-open-terminal，Ubunut14默认右键中无法打开终端
	if [ ${systemVersion} -eq 14 ]; then
		Default_Install  "nautilus-open-terminal"
		Default_AutoRemove "vim-common"		
	fi
	Default_Install  "vim"
	#第2步:安装gedit编辑器
	Default_Install  "gedit"
	#第3步:安装GCC G++
	Default_Install  "gcc g++"	
	#第4步:安装wget下载器
	Default_Install  "wget"
	#第5步:安装tcpdump抓包软件
	Default_Install  "tcpdump"
	#第6步:安装wireshark抓包软件
	Default_Install  "wireshark"
	#第7步:安装cmake编译器
	Default_Install  "cmake"
}
#CentOS默认软件安装
function CentOS_Software(){
	Log -D "调试中。。。。。。。。。。。。。。。"	
}
#默认软件安装
function Default_Software(){
	case "${systemName}" in
		Raspbian)
			Raspbian_Software
		;;
		Ubuntu)
			Ubuntu_Software
		;;
		CentOS)
			CentOS_Software
		;;
		*)
			Log -E "未知系统!"
		;;
	esac
	Log -I "Default_Software() 函数执行完成!"
}

Check_Library
SystemInformation
Default_Software