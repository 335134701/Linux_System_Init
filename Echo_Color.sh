#! /bin/bash
#默认=0，黑色=30，红色=31，绿色=32，黄色=33，蓝色=34，紫色=35，天蓝色=36，白色=37

echo 
echo -e "说明：默认=0，黑色=30，红色=31，绿色=32，黄色=33，蓝色=34，紫色=35，天蓝色=36，白色=3"
echo
echo -e "\033[30m test content黑 \033[0m" ":30m"
echo -e "\033[31m test content红 \033[0m" ":31m"
echo -e "\033[32m test content绿 \033[0m" ":32m"
echo -e "\033[33m test content黄 \033[0m" ":33m"
echo -e "\033[34m test content蓝 \033[0m" ":34m"
echo -e "\033[35m test content紫 \033[0m" ":35m"
echo -e "\033[36m test content天蓝 \033[0m" ":36m"
echo -e "\033[37m test content白 \033[0m" ":37m"