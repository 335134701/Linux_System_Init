#! /bin/bash

declare -A ConfigArray
#系统名称
systemName=""
#系统版本号
systemVersion=0

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
function Raspberry_YUM(){
    cat << EOF >  ${filename}
#阿里云镜像
deb https://mirrors.aliyun.com/raspbian/raspbian/ buster main non-free contrib
deb-src https://mirrors.aliyun.com/raspbian/raspbian/ buster main non-free contrib
EOF
    filenameBak=${ConfigArray[yumfilepath]}.d/raspi.list.bak
    filename=${ConfigArray[yumfilepath]}.d/raspi.list 
#    test ! -f ${filename} && \ 
#        Log -E "${filename} 文件不存在!" &&  exit 90
    test -f ${filename} -a ! -f ${filenameBak} && \
        sudo mv ${filename} ${filenameBak} && \
        Judge_Order "sudo mv ${filename} ${filenameBak}" 0
    sudo rm -rf ${filename}
    Judge_Order "sudo rm -rf ${filename}" 0
    sudo touch ${filename}
    Judge_Order "sudo touch ${filename}" 0
    sudo chmod 757 ${filename}
    cat << EOF >  ${filename}
#阿里云镜像
deb http://mirror.tuna.tsinghua.edu.cn/raspberrypi/ buster main ui
deb-src http://mirror.tuna.tsinghua.edu.cn/raspberrypi/ buster main ui
EOF
}
function Ubuntu_YUM(){
    case "${systemVersion}" in
        14)
            cat << EOF >  ${filename}
#阿里云镜像
deb https://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse

## Not recommended
# deb https://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
# deb-src https://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
EOF
        ;;
        16)
            cat << EOF >  ${filename}
#阿里云镜像
deb http://mirrors.aliyun.com/ubuntu/ xenial main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial main

deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main

deb http://mirrors.aliyun.com/ubuntu/ xenial universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates universe

deb http://mirrors.aliyun.com/ubuntu/ xenial-security main
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main
deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security universe
EOF
        ;;
        18)
            cat << EOF >  ${filename}
#阿里云镜像
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
EOF
        ;;
        20)
            cat << EOF >  ${filename}
#阿里云镜像
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
EOF
        ;;
    esac
    
}
function CentOS6_YUM()
{
    case "${systemVersion}" in
        6)
            sudo wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-6.repo
            Judge_Order "sudo wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-6.repo" 0
            sudo yum makecache
            Judge_Order "sudo yum makecache" 0
        ;;
        7)
            sudo wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
            Judge_Order "wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo" 0
            sudo yum makecache
            Judge_Order "sudo yum makecache" 0
        ;;
        8)
            sudo wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-8.repo
            Judge_Order "sudo wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-8.repo" 0
            sudo yum makecache
            Judge_Order "sudo yum makecache" 0
        ;;
    esac
    
}
function Change_YUM()
{
    test -z "${systemName}" -o  ${systemVersion} -eq 0 && \
        echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""\033[31m系统信息未获取成功!\033[0m" &&  exit 127
    filenameBak=${ConfigArray[yumfilepath]}.bak
    filename=${ConfigArray[yumfilepath]}
#    test ! -f ${filename} && \ 
#        Log -E "${filename} 文件不存在!" &&  exit 90
    test -f ${filename} -a ! -f ${filenameBak} && \
        sudo mv ${filename} ${filenameBak} && \
        Judge_Order "sudo mv ${filename} ${filenameBak}" 0
    sudo rm -rf ${filename}
    Judge_Order "sudo rm -rf ${filename}" 0
    sudo touch ${filename}
    Judge_Order "sudo touch ${filename}" 1
    sudo chmod 757 ${filename}
    case "${systemName}" in
        Raspbian)
            Raspberry_YUM
        ;;
        Ubuntu)
            Ubuntu_YUM
        ;;
        CentOS)
            CentOS_YUM
        ;;
        *)
            Log -E "未知系统!"
        ;;
    esac
    Log -I "Change_YUM() 函数执行完成!"
	#新安装的Ubuntu在使用sudo apt-get update更新源码的时候出现如下错误：
	#W: GPG 错误：http://mirrors.ustc.edu.cn/ros/ubuntu xenial InRelease: 由于没有公钥，无法验证下列签名： NO_PUBKEY F42ED6FBAB17C654
	#W: 仓库 “http://mirrors.ustc.edu.cn/ros/ubuntu xenial InRelease” 没有数字签名。
	#N: 无法认证来自该源的数据，所以使用它会带来潜在风险。
	#N: 参见 apt-secure(8) 手册以了解仓库创建和用户配置方面的细节。
	#解决方法很简单，下载导入公钥就行，下载导入key的命令如下：
	#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654 #此处F42ED6FBAB17C654需要是错误提示的key
}
Check_Library
Change_YUM