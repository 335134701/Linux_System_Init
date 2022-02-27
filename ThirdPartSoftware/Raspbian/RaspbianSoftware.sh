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

function RaspbianSoftware(){
	#第1步:添加python GPIO模块
	Default_Install "python3-rpi.gpio"
	#第2步:添加python OLED驱动
	Default_Install "python-smbus"
	Default_Install "i2c-tools"
	sudo python -m pip install --upgrade pip setuptools wheel
	Judge_Order "sudo python -m pip install --upgrade pip setuptools wheel" 0
	sudo apt-get install python-pip python3-pip
	Judge_Order "sudo apt-get install python-pip python3-pip" 0
	sudo apt-get install python-pil python3-pil
	Judge_Order "sudo apt-get install python-pil python3-pil" 0
	sudo pip3 install Adafruit_GPIO
	Judge_Order "sudo pip3 install Adafruit_GPIO" 0
	sudo pip3 install Adafruit_SSD1306
	Judge_Order "sudo pip3 install Adafruit_SSD1306" 0
	sudo pip3 install Adafruit_BBIO
	Judge_Order "sudo pip3 install Adafruit_BBIO" 0
}

function Main()
{
	if [ ${transfer} -eq 0 ]; then
		declare -A ConfigArray
		#系统名称
		systemName=""
		#系统版本号
		systemVersion=0
		#系统目录
		#rootDir=/home/pi/Linux/Linux_System_Init
		rootDir=$(pwd)/../../
		#当前路径
		currentDir=${rootDir}/ThirdPartSoftware/Raspbian
		#库文件路径
		LibraryPATH=${rootDir}/Library.sh
		#配置文件路径
		ConfigPATH=${rootDir}/Linux.conf
		#Step 1: 校验库文件是否存在
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
    RaspbianSoftware
}
#如果被其他主要脚本调用，则不需要执行库文件和欢迎脚本
if [ -n "${1}" -a "${1}" == "TRANSFER" ]; then
	transfer=1
fi
Main