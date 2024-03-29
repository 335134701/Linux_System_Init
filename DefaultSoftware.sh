#! /bin/bash


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
        ParseConfigurationFile
	fi
	echo
}

#配置Vsftpd
function Config_Vsftpd(){
    filename=${ConfigArray[vsftpfilepath]}
    test ! -f ${filename} && \
        Log -E "${filename} 文件不存在!" &&  exit 90
	mkdir -p ${ConfigArray[vsftdir]}
	case "${systemName}" in
		Raspbian)
			Judge_Txt "anonymous_enable.*" "anonymous_enable=NO"
			Judge_Txt "#write_enable.*" "write_enable=YES"
			Judge_Txt "local_root.*" "local_root=${ConfigArray[vsftdir]}"
			Judge_Txt "allow_writeable_chroot.*" "allow_writeable_chroot=YES"
			Judge_Txt "#xferlog_file" "xferlog_file"
			Judge_Txt "#xferlog_std_format" "xferlog_std_format"
			Judge_Txt "#idle_session_timeout" "idle_session_timeout"
			Judge_Txt "#data_connection_timeout" "data_connection_timeout"
			Judge_Txt "#ftpd_banner" "ftpd_banner"
			Judge_Txt "#chroot_local.*" "chroot_local_user=YES"
			Judge_Txt "#chroot_list_enable.*" "chroot_list_enable=NO"
			Judge_Txt "#utf8_filesystem" "utf8_filesystem"
			;;
		Ubuntu)
			Log -D "调试中。。。。。。"
		;;
		CentOS)
			Log -D "调试中。。。。。。"
		;;
		*)
			Log -E "未知系统!"
		;;
	esac
	Log -I "Config_Vsftpd() 函数执行完成!"
	echo	
}

#配置防火墙
function Config_Iptables(){
	case "${systemName}" in
		Raspbian)
			#启用防火墙
			sudo ufw enable
			#关闭外部对本机访问   
			sudo ufw default deny
			Judge_Order "sudo ufw default deny" 0
			sudo ufw allow ${ConfigArray[sshport]}
			Judge_Order "sudo ufw allow ${ConfigArray[sshport]}" 0
			sudo ufw allow ${ConfigArray[vsftpport]}
			Judge_Order "sudo ufw allow ${ConfigArray[vsftpport]}" 0
			sudo ufw allow ${ConfigArray[vsftpdataport]}
			Judge_Order "sudo ufw allow ${ConfigArray[vsftpdataport]}" 0
			sudo ufw allow ${ConfigArray[mysqlport]}
			Judge_Order "sudo ufw allow ${ConfigArray[mysqlport]}" 0
			sudo ufw allow ${ConfigArray[vncserverport]}
			Judge_Order "sudo ufw allow ${ConfigArray[vncserverport]}" 0
			#以下是防火墙相关操作说明:
				#sudo ufw allow 80 允许外部访问80端口
				#sudo ufw delete allow 80 禁止外部访问80 端口
				#sudo ufw allow from 192.168.1.1 允许此IP访问所有的本机端口
				#sudo ufw deny smtp 禁止外部访问smtp服务
				#sudo ufw delete allow smtp 删除上面建立的某条规则
				#ufw deny proto tcp from 10.0.0.0/8 to 192.168.0.1 port要拒绝所有的流量从TCP的10.0.0.0/8 到端口22的地址192.168.0.1
				#可以允许所有RFC1918网络（局域网/无线局域网的）访问这个主机（/8,/16,/12是一种网络分级）：
				#sudo ufw allow from 10.0.0.0/8
				#sudo ufw allow from 172.16.0.0/12
				#sudo ufw allow from 192.168.0.0/16
				#配置允许的端口范围 
				#sudo ufw allow 6000:6007/tcp 
				#sudo ufw allow 6000:6007/udp
			;;
		Ubuntu)
			Log -D "调试中。。。。。。"
		;;
		CentOS)
			Log -D "调试中。。。。。。"
		;;
		*)
			Log -E "未知系统!"
		;;
	esac
	Log -I "Config_Iptables() 函数执行完成!"
	echo
}

#树莓派默认软件安装
function Raspbian_Software(){
	#第1步:安装字体库
	Default_Install  "fonts-wqy-zenhei"
	#第2步:安装中文输入法
	Default_Install  "scim-pinyin"
	#第3步:安装vim编辑器
	Default_Install  "vim"
	#第4步:安装gedit编辑器
	Default_Install  "gedit"
	#第5步:安装GCC G++
	Default_Install  "gcc g++"	
	#第6步:安装openssh-server
	Default_Install  "openssh-server"
	#第7步:安装wget下载器
	Default_Install  "wget"
	#第8步:安装tcpdump抓包软件
	Default_Install  "tcpdump"
	#第9步:安装wireshark抓包软件
	Default_Install  "wireshark"
	#第10步:安装cmake编译器
	Default_Install  "cmake"
	#第11步:安装git工具
	Default_Install  "git"	
	#第12步:安装vsftpd并配置相应参数
	test ! -f '/usr/sbin/vsftpd' &&  \
		Default_Install  "vsftpd" && Config_Vsftpd && \
		sudo service vsftpd restart && \
		Judge_Order "sudo service vsftpd restart" 0
	#第13步:配置防火墙
	# test ! -f '/usr/sbin/ufw' && Default_Install  "ufw" && \
	# 	Config_Iptables
	#第13步:安装JDK
	Default_AutoRemove "default-jdk"
	Default_Install "openjdk-8-jdk"
	#第14步:安装gdbserver
	Default_Install "gdbserver"
	#第15步:安装时间同步程序ntp
	Default_Install "ntpdate"
	sudo timedatectl set-ntp true
	#修改本地时区，输入指令:sudo dpkg-reconfigure tzdata,选择 Asia/shanghai 时区
	sudo dpkg-reconfigure tzdata
	#第16步:安装qt
	Default_Install "qt5-default"
	Default_Install "qtcreator"
	Default_Install "qtmultimedia5-dev"
	Default_Install "libqt5serialport5-dev"
	#第17步:安装python3
	Default_Install "python3"
	sudo apt-get autoremove -y
	#清除当前python软链接
	sudo rm -rf /usr/bin/python
	Judge_Order "sudo rm -rf /usr/bin/python" 0
	#创建新的软链接，新版本可以使用 ls /usr/bin/python*查看最新版本
	sudo ln -s /usr/bin/python3.7 /usr/bin/python
	Judge_Order "sudo ln -s /usr/bin/python3.7 /usr/bin/python" 0
}
#Ubuntu默认软件安装
function Ubuntu_Software(){
	#第1步:安装vim编辑器，Ubunutu14 由于vim-common库版本冲突，无法安装vim，需要卸载库再进行安装
	#f附加安装nautilus-open-terminal，Ubunut14默认右键中无法打开终端
	#Ubuntu14 安装openssh-server时依赖openssh-client版本存在问题，需要安装相应的版本
	if [ ${systemVersion} -eq 14 ]; then
		Default_Install  "nautilus-open-terminal"
		Default_AutoRemove "vim-common"		
		Default_Install  "openssh-client=1:6.6p1-2ubuntu1"
	fi
	Default_Install  "vim"
	#第2步:安装gedit编辑器
	Default_Install  "gedit"
	#第3步:安装GCC G++
	Default_Install  "gcc g++"	
	#第4步:安装wget下载器
	Default_Install  "wget"
	#第5步:安装tcpdump抓包软件
	Default_Install  "tcpdump"
	#第6步:安装wireshark抓包软件
	Default_Install  "wireshark"
	#第7步:安装cmake编译器
	Default_Install  "cmake"
	#第8步:安装git工具
	Default_Install  "git"
	#第9步:安装openssh-server
	Default_Install  "openssh-server"
	#第10步:安装必要的编译环境
	Default_Install  "build-essential"
	#第11步:安装谷歌浏览器
	Default_Install  "google-chrome-stable"
}
#CentOS默认软件安装
function CentOS_Software(){
	Log -D "调试中。。。。。。。。。。。。。。。"	
}
#默认软件安装
function Default_Software(){
    test -z "${systemName}" -o  ${systemVersion} -eq 0 && \
        echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""\033[31m系统信息未获取成功!\033[0m" &&  exit 127
	case "${systemName}" in
		Raspbian)
			Raspbian_Software
		;;
		Ubuntu)
			Ubuntu_Software
		;;
		CentOS)
			CentOS_Software
		;;
		*)
			Log -E "未知系统!"
		;;
	esac
	Log -I "Default_Software() 函数执行完成!"
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
		Check_Library
        test -z "${systemName}" -o  ${systemVersion} -eq 0 && \
            echo -e "[\033[31m$(date +"%Y-%m-%d %T") Error\033[0m]  ""\033[31m系统信息未获取成功!\033[0m" &&  exit 127
		#Step 2: 执行欢迎函数
		Welcome
	fi
    #Step 3: 执行逻辑处理函数
    Default_Software
}

#如果被其他主要脚本调用，则不需要执行库文件和欢迎脚本
if [ -n "${1}" -a "${1}" == "TRANSFER" ]; then
	transfer=1
fi
Main
