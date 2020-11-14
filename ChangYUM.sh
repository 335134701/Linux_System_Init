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
function RaspberryYUM(){
    echo "#阿里云镜像" >> ${filename}
    Judge_Order "echo \"#阿里云镜像\" >> ${filename}" 1
    echo "deb https://mirrors.aliyun.com/raspbian/raspbian/ buster main non-free contrib" >> ${filename}
    Judge_Order "echo \"deb https://mirrors.aliyun.com/raspbian/raspbian/ buster main non-free contrib\" >> ${filename}" 0
    echo "deb-src https://mirrors.aliyun.com/raspbian/raspbian/ buster main non-free contrib" >> ${filename}
    Judge_Order "echo \"deb-src https://mirrors.aliyun.com/raspbian/raspbian/ buster main non-free contrib\" >> ${filename}" 0
    sudo chmod 644 ${filename}
    filenameBak=/etc/apt/sources.list.d/raspi.list.bak
    filename=/etc/apt/sources.list.d/raspi.list 
    if [ -f ${filename} -a ! -f ${filenameBak} ];then
        sudo mv ${filename} ${filenameBak}
        Judge_Order "sudo mv ${filename} ${filenameBak}" 0
    fi
    sudo rm -rf ${filename}
    Judge_Order "sudo rm -rf ${filename}" 0
    sudo touch ${filename}
    Judge_Order "sudo touch ${filename}" 0
    sudo chmod 777 ${filename}
    echo "#阿里云镜像" >> ${filename}
    Judge_Order "echo \"#阿里云镜像\" >> ${filename}" 0
    echo "deb http://mirror.tuna.tsinghua.edu.cn/raspberrypi/ buster main ui" >> ${filename}
    Judge_Order "echo \"deb http://mirror.tuna.tsinghua.edu.cn/raspberrypi/ buster main ui\" >> ${filename}" 0
    echo "deb-src http://mirror.tuna.tsinghua.edu.cn/raspberrypi/ buster main ui" >> ${filename}
    Judge_Order "echo \"deb-src http://mirror.tuna.tsinghua.edu.cn/raspberrypi/ buster main ui\" >> ${filename}" 0
}
function Ubuntu14()
{
    echo "#阿里云镜像" >> ${filename}
    Judge_Order "echo \"#阿里云镜像\" >> ${filename}" 0
    echo "deb https://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb https://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse\" >> ${filename}" 0
    echo "deb-src https://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb-src https://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse\" >> ${filename}" 0
    echo "deb https://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb https://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse\" >> ${filename}" 0
    echo "deb-src https://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb-src https://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse\" >> ${filename}" 0
    echo "deb https://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb https://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse\" >> ${filename}" 0
    echo "deb-src https://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb-src https://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse\" >> ${filename}" 0
    echo "deb https://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb https://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse\" >> ${filename}" 0
    echo "deb-src https://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb-src https://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse\" >> ${filename}" 0
}
function Ubuntu16()
{
    echo "#阿里云镜像" >> ${filename}
    Judge_Order "echo \"#阿里云镜像\" >> ${filename}" 0
    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial main" >> ${filename}
    Judge_Order "echo \"deb http://mirrors.aliyun.com/ubuntu/ xenial main\" >> ${filename}" 0
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial main" >> ${filename}
    Judge_Order "echo \"deb-src http://mirrors.aliyun.com/ubuntu/ xenial main\" >> ${filename}" 0

    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main" >> ${filename}
    Judge_Order "echo \"deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main\" >> ${filename}" 0
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main" >> ${filename}
    Judge_Order "echo \"deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main\" >> ${filename}" 0

    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial universe" >> ${filename}
    Judge_Order "echo \"deb http://mirrors.aliyun.com/ubuntu/ xenial universe\" >> ${filename}" 0
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial universe" >> ${filename}
    Judge_Order "echo \"deb-src http://mirrors.aliyun.com/ubuntu/ xenial universe\" >> ${filename}" 0
    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe" >> ${filename}
    Judge_Order "echo \"deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe\" >> ${filename}" 0
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates universe" >> ${filename}
    Judge_Order "echo \"deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates universe\" >> ${filename}" 0

    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-security main" >> ${filename}
    Judge_Order "echo \"deb http://mirrors.aliyun.com/ubuntu/ xenial-security main\" >> ${filename}" 0
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main" >> ${filename}
    Judge_Order "echo \"deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main\" >> ${filename}" 0
    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe" >> ${filename}
    Judge_Order "echo \"deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe\" >> ${filename}" 0
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security universe" >> ${filename}
    Judge_Order "echo \"deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security universe\" >> ${filename}" 0

}
function Ubuntu18()
{
    echo "#阿里云镜像" >> ${filename}
    Judge_Order "echo \"#阿里云镜像\" >> ${filename}" 0
    echo "deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse\" >> ${filename}" 0
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse\" >> ${filename}" 0

    echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse\" >> ${filename}" 0
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse\" >> ${filename}" 0

    echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse\" >> ${filename}" 0
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse\" >> ${filename}" 0

    echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse\" >> ${filename}" 0
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse\" >> ${filename}" 0

    echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse\" >> ${filename}" 0
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse\" >> ${filename}" 0

}
function Ubuntu20()
{
    echo "#阿里云镜像" >> ${filename}
    Judge_Order "echo \"#阿里云镜像\" >> ${filename}" 0
    echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse\" >> ${filename}" 0
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse\" >> ${filename}" 0

    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse\" >> ${filename}" 0
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse\" >> ${filename}" 0

    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse\" >> ${filename}" 0
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse\" >> ${filename}" 0

    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse\" >> ${filename}" 0
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse\" >> ${filename}" 0

    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse\" >> ${filename}" 0
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >> ${filename}
    Judge_Order "echo \"deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse\" >> ${filename}" 0

}
function CentOS6()
{
    sudo wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-6.repo
    Judge_Order "sudo wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-6.repo" 0
    sudo yum makecache
    Judge_Order "sudo yum makecache" 0
}
function CentOS7()
{
    sudo wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
    Judge_Order "wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo" 0
    sudo yum makecache
    Judge_Order "sudo yum makecache" 0
}
function CentOS8()
{
    sudo wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-8.repo
    Judge_Order "sudo wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-8.repo" 0
    sudo yum makecache
    Judge_Order "sudo yum makecache" 0
}
function Change_YUM()
{
    if [ ${systemName} = "CentOS" ];then
        filenameBak=/etc/yum.repos.d/CentOS-Base.repo.bak
        filename=/etc/yum.repos.d/CentOS-Base.repo
    elif [ ${systemName} = "Ubuntu" -o ${systemName} = "Raspbian" ];then
        filenameBak=/etc/apt/sources.list.bak
	    filename=/etc/apt/sources.list
    fi
    if [ -f ${filename} -a ! -f ${filenameBak} ];then
        sudo mv ${filename} ${filenameBak}
        Judge_Order "sudo mv ${filename} ${filenameBak}" 0
    elif [ -f ${filename} -a -f ${filenameBak} ];then
        sudo rm -rf ${filename}
        Judge_Order "sudo rm -rf ${filename}" 0
    fi
    sudo touch ${filename}
    Judge_Order "sudo touch ${filename}" 1
    sudo chmod 777 ${filename}
    if [ ${systemName} = "Raspbian" ];then
        RaspberryYUM
    elif [ ${systemName} = "Ubuntu" -a ${systemVersion} = "14" ];then
        Ubuntu14
    elif [ ${systemName} = "Ubuntu" -a ${systemVersion} = "16" ];then
        Ubuntu16
    elif [ ${systemName} = "Ubuntu" -a ${systemVersion} = "18" ];then
        Ubuntu18
    elif [ ${systemName} = "Ubuntu" -a ${systemVersion} = "20" ];then    
        Ubuntu20 
    elif [ ${systemName} = "CentOS" -a ${systemVersion} = "6" ];then    
        CentOS6 
    elif [ ${systemName} = "CentOS" -a ${systemVersion} = "7" ];then    
        CentOS7
    elif [ ${systemName} = "CentOS" -a ${systemVersion} = "8" ];then    
        CentOS8
    fi
    sudo chmod 644 ${filename}
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
SystemInformation
Change_YUM