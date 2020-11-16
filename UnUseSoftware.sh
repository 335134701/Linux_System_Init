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
#处理函数
function Remove(){
    if [ ${#} -eq 1 ]; then
        if [ ${systemName} = "Raspbian" -o  ${systemName} = "Ubuntu" ]; then
            sudo apt-get autoremove ${1} -y
            Judge_Order "sudo apt-get autoremove ${1} -y" 1
        elif [ ${systemName} = "CentOS" ]; then
            sudo yum autoremove ${1} -y
            Judge_Order "sudo yum autoremove ${1} -y" 1
        fi
    else
        Log -E "函数参数输入有误!"
    fi
    
}
#以下函数还可以进行优化处理，优化方式是形成函数
#卸载Ubuntu默认，无用软件
function Remove_Unusing_Software(){
    if [ ${systemName} = "Raspbian" ];then
        Log -I "暂未找到无用软件!"
    elif [ ${systemName} = "Ubuntu" ];then
        #雷鸟邮件客户端
        Remove "thunderbird"
        #自带播放器
        Remove "totem"
        #扫描仪
        Remove "simple-scan"
        #数独游戏
        Remove "gnome-sudoku"
        #对对碰游戏
        Remove "gnome-mahjongg"
        #扫雷游戏
        Remove "gnome-mines"
        #备份
        Remove "deja-dup"
        #Amazon商店
        Remove "unity-webapps-common"
        #自带的音乐播放器
        Remove "rhythmbox"
        #自带的即时聊天应用
        Remove "empathy"
        if [ ${systemVersion} = "14" ];then
            Remove "brasero"
            #软件中心
            Remove "software-center"
        elif [ ${systemVersion} = "16" -o ${systemVersion} = "18" ];then
            #软件中心
            Remove "gnome-software"
        elif [ ${systemVersion} = "20" ];then
            Log -D "还未找到卸载软件中心的办法!"
        fi
    elif [ ${systemName} = "CentOS" ];then
         Log -I "暂未找到无用软件!"
    fi
	Log -I "Remove_Unusing_Software() 方法执行完成!"
}
Check_Library
SystemInformation
Remove_Unusing_Software