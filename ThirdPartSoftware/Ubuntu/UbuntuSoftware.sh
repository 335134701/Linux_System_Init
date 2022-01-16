#! /bin/bash

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
        ParseConfigurationFile
	fi
	echo
}

#谷歌浏览器安装
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
	Judge_Txt 'export\ PATH=\/opt\/google\/chrome:\$PATH' "export\ PATH=\/opt\/google\/chrome:\$PATH"
#	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654
#	Judge_Order "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654" 1
	sudo rm -rf ${currentDir}/google-chrome.deb
	Judge_Order "sudo rm -rf ${currentDir}/google-chrome.deb" 1
	#启动谷歌浏览器
	/usr/bin/google-chrome-stable
}

#树莓派交叉编译环境搭建
function RaspbianCompilationEnv() {
	sudo apt install gcc-arm-linux-gnueabihf -y
	sudo apt install g++-arm-linux-gnueabihf -y
}


function UbuntuSoftware(){
    #第一步:谷歌浏览器安装
	Chrome_Install
	#第二步:安装树莓派交叉编译环境,默认不安装
	#RaspbianCompilationEnv
}

function Main()
{
	if [ ${transfer} -eq 0 ]; then
		#Step 1: 校验库文件是否存在
		declare -A ConfigArray
		#系统名称
		systemName=""
		#系统版本号
		systemVersion=0
		#系统目录
		#rootDir=/home/pi/Linux/Linux_System_Init
		rootDir=$(pwd)/../..
		#当前路径
		currentDir=${rootDir}/ThirdPartSoftware/Ubuntu
		#库文件路径
		LibraryPATH=${rootDir}/Library.sh
		#配置文件路径
		ConfigPATH=${rootDir}/Linux.conf
		Check_Library
        test -z "${systemName}" -o  ${systemVersion} -eq 0 && \
            echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""\033[31m系统信息未获取成功!\033[0m" &&  exit 127
		#Step 2: 执行欢迎函数
		Welcome
	else
		rootDir=${rootDir}
		#当前路径
		currentDir=${rootDir}/ThirdPartSoftware/Ubuntu
		#库文件路径
		LibraryPATH=${currentDir}
		#配置文件路径
		ConfigPATH=${ConfigPATH}
	fi
    #Step 3: 执行逻辑处理函数
    UbuntuSoftware
}
#如果被其他主要脚本调用，则不需要执行库文件和欢迎脚本
if [ -n "${1}" -a "${1}" == "TRANSFER" ]; then
	transfer=1
fi
Main