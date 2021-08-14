#! /bin/bash

declare -A ConfigArray
#系统名称
systemName=""
#系统版本号
systemVersion=0

#当前文件目录
currentDir=$(pwd)/ThirdPartSoftware/Ubuntu

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

function Chrome_Install()
{
	sudo rm -rf ${currentDir}/google-chrome*
	wget -O ${currentDir}/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	Judge_Order "wget -O ${currentDir}/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" 0
	Update_All
	sudo dpkg -i ${currentDir}/google-chrome.deb
	Judge_Order "sudo dpkg -i ${currentDir}/google-chrome.deb" 0
	#实现命令行输入chrome即可启动谷歌浏览器
	filename=${HOME}/.bashrc
	Judge_Txt "export\ PATH=\/opt\/google\/chrome:\$PATH"
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654
	Judge_Order "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654" 1
	sudo rm -rf${currentDir}/google-chrome.deb
	Judge_Order "sudo rm -rf ${currentDir}/google-chrome.deb" 1
}

function UbuntuSoftware(){
    #第一步:谷歌浏览器安装
	Chrome_Install
}

Check_Library
UbuntuSoftware