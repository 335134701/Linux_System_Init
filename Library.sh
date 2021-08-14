#! /bin/bash

#**********************************************************
# 错误代码说明：
	# 0:表示正确
	# 1:表示错误 
    # 80:函数输入参数与实际参数不一致，返回值为80
	# 81:表示参数不匹配错误
	# 82:表示函数不存在错误
	# 90:表示文件不存在错误
	# 91:表示目录不存在
	# 127:表示命令执行失败
#**********************************************************


INFOTime="[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  "
WARNTime="[\033[33m$(date +"%Y-%m-%d %T") Warning\033[0m]  "
DEBUGTime="[\033[34m$(date +"%Y-%m-%d %T") Warning\033[0m]  "
ERRORTime="[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  "
userName=${USER}
softwareRootDir=${HOME}/Software
softwareDir=${HOME}/Software
configFile=$(pwd)/Linux.conf

#欢迎函数
function Welcome()
{
	echo
	echo
	echo -e "\033[34m*****************************************************\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	local localFileName=${0#*/}
	((bitNum=(49-11-${#localFileName})/2))
	if [ ${#localFileName} -lt 38 ];then
		echo -e "\033[34m**\033[0m\c"
		for((i=0;i<${bitNum};i++))
		do
			echo -e " \c"
		done
		echo -e "\033[34mWelcome to \033[0m\033[33m${localFileName}\033[0m\c"
		((bitNum=49-${bitNum}-11-${#localFileName}))
		for((i=0;i<${bitNum};i++))
		do
			echo -e " \c"
		done
		echo -e "\033[34m**\033[0m\c"
		echo
	fi
	echo -e "\033[34m**                                                 **\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	echo -e "\033[34m**                                                 **\033[0m"
	echo -e "\033[34m*****************************************************\033[0m"
	echo
	echo
}
#logger输出函数
#参数表示：I:Info D:Debug W:Warn E:Error 
function Log()
{
    unset OPTIND
	while getopts "I:D:W:E:" arg 
    do
        case "${arg}" in
            I)
                echo -e "[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  ""\033[32m${OPTARG}\033[0m"
            ;;
            D)
                echo -e "[\033[34m$(date +"%Y-%m-%d %T") Warning\033[0m]  ""\033[34m${OPTARG}\033[0m"
            ;;
            W)
                echo -e "[\033[33m$(date +"%Y-%m-%d %T") Warning\033[0m]  ""\033[33m${OPTARG}\033[0m"
            ;;
            E)
                echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""\033[31m${OPTARG}\033[0m"
            ;;
            ?)
                echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""\033[31mLog参数输入错误!\033[0m"
            ;;
        esac
    done
}
#获取系统相关信息
function SystemInformation()
{
	systemName=$(cat /etc/issue | cut -d " " -f1)
	case "${systemName}" in
		Raspbian)
			systemVersion=$(cat /etc/issue | cut -d " " -f3)	
		;;
		Ubuntu)
			systemVersion=$(cat /etc/issue | cut -d " " -f2| cut -d "." -f1)
		;;
		CentOS)
			systemVersion=$(cat /etc/issue | cut -d " " -f2| cut -d "." -f1)
		;;
		*)
			Log -E "系统名称获取失败,脚本将终止运行!"
			exit 127
		;;
	esac
	Log -I "欢迎使用${systemName}系统,系统版本号为 ${systemVersion} !"
	echo
}
#判断命令是否执行成功
#${1}:执行的命令语句
function Judge_Order(){
	local status=${?}
	test  ${#} -ne 2 && \
		Log -E "函数传入参数错误!" && return 80
	#判断上一条命令的返回值是否为0，若为0则执行成功，若不为0则执行失败
	if [ ${status} -eq 0 ];then
		Log -I "\"${1}\" 执行成功!"
	else 
		Log -E "\"${1}\" 执行失败!"
		test ${2} -eq 0 && 	exit 127
	fi
    echo
}
#解析配置文件
function ParseConfigurationFile()
{
	#配置文件关联数组
	test ! -f ${configFile} && \
		Log -E "配置文件 ${configFile} 不存在!" && exit 90
	test -z ${systemName} && \
		Log -E "系统信息获取失败,程序结束!" && exit 127
	#解析脚本名称
	ScriptArray=(`sed -n '/\['Script_File'\]/,/\[/p' ${configFile}|grep -Ev '\[|\]|^$|^#'`)
	indexName=(`sed -n '/\['${systemName}.Config'\]/,/\[/p' ${configFile}|grep -Ev '\[|\]|^$|^#'|awk -F '=' '{print $1}'`)
    indexValues=(`sed -n '/\['${systemName}.Config'\]/,/\[/p' ${configFile}|grep -Ev '\[|\]|^$|^#'|awk -F '=' '{print $2}'`)
	for((i=0;i<${#indexName[*]};i++)); do		
		ConfigArray[${indexName[i]}]=${indexValues[i]}			
	done
	test ${#ScriptArray[@]} -eq 0 -o ${#ConfigArray[@]} -eq 0  && \
		Log -W "${configFile} 配置文件解析失败！" && exit 127
	Log -I "${configFile} 配置文件解析成功!"
}	
#判断方法是否继续执行
#${1}:传入用户选择；
#${2}:传入需要执行的方法
function Judge_MethodIsExecute()
{
	echo
	local mtehodStatus=126
	test ${#} -ne 2 && \
		Log -E "函数传入参数错误!" && return 126
	test -z ${1} && \
		Log -W "你在5秒内未确认是否执行方法,\"${2}\" 将默认执行!" && return 125
	test  ${1} = 'Y' -o ${1} = 'y' && \
		Log -I "你选择的是 \"${1}\" \"${2}\" 将开始执行!" && return 0
	test  ${1} = 'N' -o ${1} = 'n' && \
		Log -W "你选择的是 \"${1}\" \"${2}\" 将不执行!" && return 1
	test -n ${1} && \
		Log -W "你输入未知确认参数,\"${2}\" 将默认执行!" && return 124
	echo
}
#配置文件修改
#${1} 匹配内容
#${2} 插入内容
#${3} 说明
#当result值为不空时，${3}=1表示在${1}上一行插入${2}
#当result值为不空时，${3}=2表示在${1}下一行插入${2}
function Judge_Txt()
{
	local result=''
	test  ${#} -lt 1 -o ${#} -gt 3 &&
		Log -E "函数传入参数错误!" && return 80
	#文件不存在或为空
	test $(cat ${filename} 2>&1 | wc -l) -eq 0 -o ! -f ${filename} && \
		echo ${2} > ${filename} && return 0
	test ! -f ${filename} && Log -E "${filename} 文件不存在!" && exit 90
	#查找以${1}开头的内容
	result=(`sudo egrep -n "${1}" ${filename} | cut -d ":" -f1`)
	echo ${result}
	test -z "${result}" -a ${#} -eq 2 && \
		sudo sed -i \$a"${2}"  ${filename}  && \
		Judge_Order "sudo sed -i \$a\"${2}\"  ${filename}" 0 && return 0
	test -n "${result}" -a ${#} -eq 2 && \
		sudo sed -i 's/'"${1}/${2}"'/g' ${filename} && \
		Judge_Order "sudo sed -i 's/'\"${1}/${2}\"'/g' ${filename}" 0 && return 0
	if [ -n "${result}" ] && [ ${#} -eq 3 ] && [ ${3} -eq 1 ]; then
		test -z `sudo grep -E -n ^"${2}" ${filename}` && \
			sudo sed -i "${result}i${2}"  ${filename} && \
			Judge_Order "sudo sed -i \"${result}i${2}\"  ${filename}" 0	 && return 0
	fi
	if [ -n "${result}" ] && [ ${#} -eq 3 ] && [ ${3} -eq 2 ]; then
		test -z `sudo grep -E -n ^"${2}" ${filename}` && \
			sudo sed -i "${result}a${2}"  ${filename} && \
			Judge_Order "sudo sed -i \"${result}a${2}\"  ${filename}" 0	 && return 0
	fi	
}

#处理重复性软件流程
#${1}:执行方法名称
function Software_Install()
{
	echo
	local isChoose='Y'
	local isChooseMode=126
	test ${#} -ne 1 && \
		Log -E "函数传入参数错误!" && return 80
	test ! -f ${1} &&
		Log -E "${1} 不存在!" && return 90
#	test "$(type -t ${1})" != "function" && \
#		Log -E "${1}() 函数不存在!" && return 82
	read -t 5 -n 1 -p "请确认是否执行 ${1} (Y/N):" isChoose
	echo
	#Determine whether to execute method
	Judge_MethodIsExecute "${isChoose}" ${1}
	#Get Judge_MethodIsExecute() function return value
	isChooseMode=${?}
	#Determine whether to execute  method
	test ${isChooseMode} -ne 1 -a ${isChooseMode} -ne 126  && \
		sudo chmod 744 ${1} && ${1} && echo &&Judge_Order "${1}" 1
	echo
}
#更新软件
function Update_All()
{
	if [ ${systemName} = "Raspbian" -o ${systemName} = "Ubuntu" ];then
			sudo apt-get upgrade -y
			Judge_Order "sudo apt-get upgrade -y" 1
			sudo apt-get update -y
			Judge_Order "sudo apt-get update -y" 1
			sudo apt-get -f install -y
			Judge_Order "sudo apt-get -f install -y" 1
			sudo apt-get autoremove -y
			Judge_Order "sudo apt-get autoremove -y" 1
	elif [ ${systemName} = "CentOS" ];then
			sudo yum upgrade -y
			Judge_Order "sudo yum upgrade -y" 1
			sudo yum update -y
			Judge_Order "sudo yum update -y" 1
			sudo yum -f install -y
			Judge_Order "sudo yum -f install -y" 1
			sudo yum autoremove -y
			Judge_Order "sudo yum autoremove -y" 1
	else
			Log -E "未获取到系统信息,无法做适配处理,脚本将终止运行!"
			exit 127
	fi
    Log -I "Update_All() 函数执行完成!"
}
#判断对应的目录是存在
function  Determine_SoftwareFold_Exist()
{
	test ${#} -ne 1 && \
	Log -E "函数传入参数错误!" && return 80
	if [ -d "${softwareRootDir}" ];then
		Log -W "${softwareRootDir} 目录已存在!"
	else
		mkdir -p ${softwareRootDir}
		Log -I "${softwareRootDir} 目录创建成功!"
	fi
	if [ -d "${softwareRootDir}/${1}" ];then
		Log -W "${softwareRootDir}/${1} 目录已存在!"
	else
		mkdir -p ${softwareRootDir}/${1}
		Log -I "${softwareRootDir}/${1} 目录创建成功!"	
	fi
}
#安装默认软件处理函数
function Default_Install(){
	test ${#} -ne 1 && \
		Log -E "函数传入参数错误!" && return 80
	if [ ${systemName} = "Raspbian" -o  ${systemName} = "Ubuntu" ]; then
		sudo apt-get install ${1} -y
		Judge_Order "sudo apt-get install ${1} -y" 1
	elif [ ${systemName} = "CentOS" ]; then
		sudo yum install ${1} -y
		Judge_Order "sudo yum install ${1} -y" 1
	fi
}
#卸载默认软件处理函数
function Default_AutoRemove(){
	test ${#} -ne 1 && \
		Log -E "函数传入参数错误!" && return 80
	if [ ${systemName} = "Raspbian" -o  ${systemName} = "Ubuntu" ]; then
		sudo apt-get autoremove ${1} -y
		Judge_Order "sudo apt-get autoremove ${1} -y" 1
	elif [ ${systemName} = "CentOS" ]; then
		sudo yum autoremove ${1} -y
		Judge_Order "sudo yum autoremove ${1} -y" 1
	fi
}

#执行其他脚本文件
#${1}:脚本文件名称及目录
function Run_SHFile()
{
	if [ -f $(pwd)/${1} ];then
		sudo chmod 755 ${1}
		${1}
		Judge_Order ${1} 1
	else
		Log -E "$(pwd)/${1} 脚本不存在!"
	fi
}