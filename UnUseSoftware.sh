#! /bin/bash

declare -A ConfigArray
#系统名称
systemName=""
#系统版本号
systemVersion=0
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
        systemName=${systemLibraryName}
		systemVersion=${systemLibraryVersion}
        ParseConfigurationFile
	fi
	echo
}


#树莓派卸载无用软件
function Raspbian_UnUseSoftware()
{
    Log -I "暂未找到无用软件!"
    echo
}
#Ubuntu卸载无用软件
function Ubuntu_UnUseSoftware()
{
    #雷鸟邮件客户端
    Default_AutoRemove "thunderbird"
    #自带播放器
    Default_AutoRemove "totem"
    #扫描仪
    Default_AutoRemove "simple-scan"
    #数独游戏
    Default_AutoRemove "gnome-sudoku"
    #对对碰游戏
    Default_AutoRemove "gnome-mahjongg"
    #扫雷游戏
    Default_AutoRemove "gnome-mines"
    #备份
    Default_AutoRemove "deja-dup"
    #Amazon商店
    Default_AutoRemove "unity-webapps-common"
    #自带的音乐播放器
    Default_AutoRemove "rhythmbox"
    #自带的即时聊天应用
    Default_AutoRemove "empathy"
    if [ ${systemVersion} = "14" ];then
        Default_AutoRemove "brasero"
        #软件中心
        Default_AutoRemove "software-center"
    elif [ ${systemVersion} = "16" -o ${systemVersion} = "18" ];then
        #软件中心
        Default_AutoRemove "gnome-software"
    elif [ ${systemVersion} = "20" ];then
        Log -D "还未找到卸载软件中心的办法!"
    fi
}
#CentOS卸载无用软件
function CentOS_UnUseSoftware()
{
    Log -I "暂未找到无用软件!"
}

#以下函数还可以进行优化处理，优化方式是形成函数
#卸载Ubuntu默认，无用软件
function Remove_Unusing_Software(){
    test -z "${systemName}" -o  ${systemVersion} -eq 0 && \
        echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""\033[31m系统信息未获取成功!\033[0m" &&  exit 127
	case "${systemName}" in
		Raspbian)
			Raspbian_UnUseSoftware
		;;
		Ubuntu)
			Ubuntu_UnUseSoftware
		;;
		CentOS)
			CentOS_UnUseSoftware
		;;
		*)
			Log -E "未知系统!"
		;;
	esac
	Log -I "Remove_Unusing_Software() 方法执行完成!"
}

function Main()
{
	if [ ${transfer} -eq 0 ]; then
		#Step 1: 校验库文件是否存在
		Check_Library
        test -z "${systemName}" -o  ${systemVersion} -eq 0 && \
            echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""\033[31m系统信息未获取成功!\033[0m" &&  exit 127
		#Step 2: 执行欢迎函数
		Welcome
	fi
    #Step 3: 执行逻辑处理函数
    Remove_Unusing_Software
}

#如果被其他主要脚本调用，则不需要执行库文件和欢迎脚本
if [ -n "${1}" -a "${1}" == "TRANSFER" ]; then
	transfer=1
fi
Main