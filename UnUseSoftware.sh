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
#以下函数还可以进行优化处理，优化方式是形成函数
#卸载Ubuntu默认，无用软件
function Remove_Unusing_Software(){
    if [ ${systemName} = "Raspbian" ];then
        Log -I "暂未找到无用软件!"
    elif [ ${systemName} = "Ubuntu" ];then
        #雷鸟邮件客户端
        sudo apt-get remove thunderbird -y
        Judge_Order "sudo apt-get remove thunderbird -y" 1
        #自带播放器
        sudo apt-get remove totem -y
        Judge_Order "sudo apt-get remove totem -y" 1
        #扫描仪
        sudo apt-get remove simple-scan -y
        Judge_Order "sudo apt-get remove simple-scan -y" 1
        #纸牌游戏
        sudo apt-get remove aisleriot -y
        Judge_Order "sudo apt-get remove aisleriot -y" 1
        #数独游戏
        sudo apt-get remove gnome-sudoku -y
        Judge_Order "sudo apt-get remove gnome-sudoku -y" 1
        #对对碰游戏
        sudo apt-get remove gnome-mahjongg -y
        Judge_Order "sudo apt-get remove gnome-mahjongg -y" 1
        #扫雷游戏
        sudo apt-get remove gnome-mines -y
        Judge_Order "sudo apt-get remove gnome-mines  -y" 1
        #备份
        sudo apt-get remove deja-dup -y
        Judge_Order "sudo apt-get remove deja-dup -y" 1
        #Amazon商店
        sudo apt-get remove unity-webapps-common -y
        Judge_Order "sudo apt-get remove unity-webapps-common -y" 1
        #自带的音乐播放器
        sudo apt-get remove rhythmbox -y
        Judge_Order "sudo apt-get remove rhythmbox -y" 1
        #自带的即时聊天应用
        sudo apt-get remove empathy -y
        Judge_Order "sudo apt-get remove empathy -y" 1
        if [ ${systemVersion} = "14" ];then
            sudo apt-get remove brasero -y
            Judge_Order "sudo apt-get remove brasero -y" 1
            #软件中心
            sudo apt-get remove software-center -y
            Judge_Order "sudo apt-get remove software-center -y" 1
        elif [ ${systemVersion} = "16" ];then
            #软件中心
            sudo apt-get remove gnome-software -y
            Judge_Order "sudo apt-get remove gnome-software -y" 1
        elif [ ${systemVersion} = "18" ];then
             #软件中心
            sudo apt-get remove gnome-software -y
            Judge_Order "sudo apt-get remove gnome-software -y" 1
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