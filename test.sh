#! /bin/bash
function Determine_Execute_Method()
{
	echo
	echo
	Method_Status=127
	if [ ${#} -eq 1 ];then
		read -t 15 -p "Do you need to implement the ${1} method(Y/N)?" answers && echo && echo
		if [[ ${answers} == "Y" ]] || [[ ${answers} == "y" ]];then
			echo -e "\033[36mYour input is ${answers}, the ${1} method will execute!\033[0m"
			Method_Status=0
		elif  [[ ${answers} == "N" ]] || [[ ${answers} == "n" ]];then
			echo -e "\033[36mYour input is ${answers}, the ${1} method will not execute!\033[0m"
			Method_Status=1
		elif  [[ -z ${answers} ]];then
			echo -e "\033[36mYou have no input, the method will be executed by default!\033[0m"
			Method_Status=0
		else
			echo -e "\033[31mYou make a mistake, please try again!\033[0m"
			Determine_Execute_Method ${1}
		fi
	else
		echo -e "\033[31mMethod input parameters are incorrect, the program method is coming to an end!\033[0m"	
	fi
	echo
	echo
}
Determine_Execute_Method  "fgdsfg"
echo ${Method_Status}
