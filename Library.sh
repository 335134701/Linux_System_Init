#! /bin/bash


#**********************************************************
# 错误代码说明：
	# 0:表示正确
	# 1:表示错误 
    # 80:函数输入参数与实际参数不一致，返回值为80
	# 81:表示参数不匹配错误
	# 82:表示函数不存在错误
	# 90:表示文件不存在错误
	# 127:表示命令执行失败
#**********************************************************


INFOTime=="[\033[32m$(date +"%Y-%m-%d %T") Info\033[0m]  "
WARNTime="[\033[33m$(date +"%Y-%m-%d %T") Warning\033[0m]  "
DEBUGTime="[\033[34m$(date +"%Y-%m-%d %T") Warning\033[0m]  "
ERRORTime="[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  "
userName=${USER}
softwareRootDir=${HOME}/Software
softwareDir=${HOME}/Software

#欢迎函数
function Welcome()
{
	echo
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
	echo
}

#获取系统相关信息
function SystemInformation()
{
	echo
	systemName=$(cat /etc/issue | cut -d " " -f1)
	if [ ${systemName} = "Raspbian" ];then
		systemVersion=$(cat /etc/issue | cut -d " " -f3)
		Log -I "欢迎使用Raspbian系统,系统版本号为 ${systemVersion} !"
	elif [ ${systemName} = "Ubuntu" ];then
		systemVersion=$(cat /etc/issue | cut -d " " -f2| cut -d "." -f1)
		Log -I "欢迎使用Ubuntu系统,系统版本号为 ${systemVersion} !"
	elif [ ${systemName} = "CentOS" ];then
		systemVersion=$(cat /etc/issue | cut -d " " -f2| cut -d "." -f1)
		Log -I "欢迎使用CentOS系统,系统版本号为 ${systemVersion} !"
	else
		Log -E "系统名称获取失败,脚本将终止运行!"
		exit 127
	fi
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
#判断命令是否执行成功
#${1}:执行的命令语句
function Judge_Order(){
	local status=${?}
    echo
	if [ ${#} -eq 2 ];then
		#判断上一条命令的返回值是否为0，若为0则执行成功，若不为0则执行失败
		if [ ${status} -eq 0 ];then
            Log -I "\"${1}\" 执行成功!"
		else 
            Log -E "\"${1}\" 执行失败!"
			if [ "${2}" -eq 0 ];then
				exit 127
			fi
		fi
		
	else
		Log -E "函数传入参数错误!"
		return 80
	fi
    echo
}
#更新软件
function Update_All()
{
	echo
	echo
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
	echo
	echo
}
#判断方法是否继续执行
#${1}:传入用户选择；
#${2}:传入需要执行的方法
function Judge_MethodIsExecute()
{
	echo
	local mtehodStatus=126	
	if [ ${#} -eq 2 ];then
		if [[ ${1} = 'Y' || ${1} = 'y' ]];then
			mtehodStatus=0
            Log -I "你选择的是 \"${1}\" 方法 \"${2}()\" 将开始执行!"
		elif [[ ${1} = 'N' || ${1} = 'n' ]];then
			mtehodStatus=1
			Log -I "你选择的是 \"${1}\" 方法 \"${2}()\" 将不执行!"
		elif [ -z ${1} ];then
			mtehodStatus=125
			Log -W "你在5秒内未确认是否执行方法,方法 \"${2}()\" 将默认执行!"
		else
			mtehodStatus=124
			Log -W "你输入未知确认参数,方法 \"${2}()\" 将默认执行!"
		fi
	else
		Log -E "函数传入参数错误!"
		return 80
	fi
	echo
	return ${mtehodStatus}
}
#配置文件修改
#当result值为不空时，${3}=1表示在${1}上一行插入${2}
#当result值为不空时，${3}=2表示在${1}下一行插入${2}
function Judge_Txt()
{
	echo
	local result=''
	if [ ${#} -ge 1 ] && [ ${#} -le 3 ];then
		if [ $(cat ${filename} 2>&1 | wc -l) -eq 0 ] || [ ! -f ${filename} ] ;then
			echo ${1} > ${filename}
		else
			if [ ! -f ${filename} ];then
		        Log -E "${filename} 文件不存在!"	
		        exit 90
	        fi
			result=`sudo grep -E -n ^"${1}" ${filename} | cut -d ":" -f 1` 
			if [ -z "${result}" ];then
				result=`sudo grep -E -n "${1}" ${filename} | cut -d ":" -f 1` 
			fi
			if [ -z "${result}" ] && [ ${#} -eq 1 ];then
				sudo sed -i \$a"${1}"  ${filename}
				Judge_Order "sudo sed -i \$a\"${1}\"  ${filename}" 0
			elif [ -n "${result}" ] && [[ ${3} -eq 1 ]];then
				resultt=`sudo grep -E -n ^"${2}" ${filename}`
				if [ -z "${resultt}" ];then 
					sudo sed -i "${result}i${2}"  ${filename}
					Judge_Order "sudo sed -i \"${result}a${2}\"  ${filename}" 0
				fi
			elif [ -n "${result}" ] && [[ ${3} -eq 2 ]];then
				resultt=`sudo grep -E -n ^"${2}" ${filename}`
				if [ -z "${resultt}" ];then 
					sudo sed -i "${result}a${2}"  ${filename}
					Judge_Order "sudo sed -i \"${result}a${2}\" ${filename}" 0
				fi
			elif [ -n "${result}" ] && [ ${#} -eq 2 ];then
				sudo sed -i 's/'"${1}/${2}"'/g'  ${filename}
				Judge_Order "sudo sed -i 's/'\"${1}/${2}\"'/g'  ${filename}" 0
			fi
		fi
	else
		Log -E "函数传入参数错误!"
		return 80
	fi
	echo 
}

#处理重复性软件流程
#${1}:执行方法名称
function Software_Install()
{
	echo
	local isChoose='Y'
	local isChooseMode=126
	if [ ${#} -eq 1 ];then
		if [ "$(type -t ${1})" = "function" ] ; then
    			read -t 5 -n 1 -p "请确认是否执行 ${1}() 方法(Y/N):" isChoose
			echo
			#Determine whether to execute method
			Judge_MethodIsExecute "${isChoose}" ${1}
			#Get Judge_MethodIsExecute() function return value
			isChooseMode=${?}
			#Determine whether to execute  method
			if [ ${isChooseMode} -ne 1 ] && [ ${isChooseMode} -ne 126 ];then
				${1}
			fi
		else
			Log -E "函数不存在!"
			return 82
		fi
		
	else
		Log -E "函数传入参数错误!"
		return 80	
	fi
	echo
}

#执行其他脚本文件
#${1}:脚本文件名称及目录
function Run_SHFile()
{
	if [ -f ${1} ];then
		sudo chmod 744 ${1}
		${1}
		Judge_Order "${1}" 1
	else
		Log -E "${1} 脚本不存在!"
	fi
}

#判断对应的目录是存在
function  Determine_SoftwareFold_Exist()
{
	echo
	echo
	if [ ${#} -eq 1 ];then
		if [ -d "${HOME}/Software" ];then
			Log -W "${HOME}/Software 目录已存在!"
		else
			mkdir ${HOME}/Software
			Log -I "${HOME}/Software 目录创建成功!"
		fi
		if [ -d "${HOME}/Software/${1}" ];then
			Log -W "${HOME}/Software/${1} 目录已存在!"
		else
			mkdir ${HOME}/Software/${1}
			Log -I "${HOME}/Software/${1} 目录创建成功!"	
		fi
	else
		Log -E "函数传入参数错误!"
	fi
	echo
	echo
}

