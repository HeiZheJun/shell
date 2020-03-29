 #!/bin/bash
 ##这是一个多功能的shell
 red="\033[31m"
 green="\033[32m"
 end="\033[0m"

 q1() {
 	#计算目录下文件夹,文件的功能
 	read -p "请输入路径：" Path
 	a=`ls -l ${Path} | grep "^d" |wc -l`
 	b=`ls -lR ${Path} | grep "^d" |wc -l`
 	c=`ls -l ${Path} | grep "^-" |wc -l`
 	d=`ls -lR ${Path} | grep "^-" |wc -l`
 	echo -e "$1目录下有${green}${a}个文件夹${end}"
 	echo -e "$1目录和子目录一共下有${green}${b}个文件夹${end}"
 	echo -e "$1目录下有${green}${c}个文件${end}"
 	echo -e "$1目录和子目录下一共有${green}${d}个文件${end}"
 }

 q2() {
 	#计算从0到你输入的数字之和
 	read -p "请输入要计算的数字：" number
 	i=0
 	s=0
 	while [ ${i} -le ${number} ];do
 		s=$((${s}  + ${i}))
 		i=$((${i} + 1))
 	done
 	echo -e "从0到$1数字之和是${green}${s}${end}"

 }

 q3() {
 	#创建用户
 	read -p "请输入要创建的用户名:" user
 	useradd  ${user}
 	if [[ $? -eq 0  ]]; then
 		read -s -p "请输入${user}的密码:" passwd
 		echo "${passwd}" |passwd  --stdin ${user}
 		echo -e "\n"
 	else
 		echo "用户创建失败。请检查用户名是否符合标准"
 	fi
 }


q4() {
 	#检测用户密码是否正确
	yum list installed | grep "expect" >/dev/null 2>&1
	if [[ $? -ne 0 ]]; then
		echo -e "未安装expect\n安装中..."
		lujing=`pwd`
		yum -y install expect >>${pwd}/ERROR.log 2>&1
		if [[ $? -ne 0 ]]; then
			echo "安装成功"
		else
			echo "安装失败，请查看日志文件${pwd}/ERROR.log" 
		fi
	fi
	read -p "请输入用户名：" user1
	cat /etc/passwd | awk -F ":" '{print $1}' | grep -w "${user1}" >>/dev/null 2>&1
	if [[ $? -ne 0 ]]; then
		echo -e "\033[1;31m用户不存在\033[0m"
		#statements
	else
		read -p "请输入密码：" passwd1
		#set time 10##此语句是expect
		expect << EOF
set time 2
spawn ssh ${user1}@localhost
expect	"pa"
send "$passwd1\r"
expect eof
EOF
		if [[ $? -eq 0 ]]; then
			echo 成功
			#statements
		fi

	fi
 }


 q5() {
 	#检测网络连通性
 	read -p "请输入IP：" IP
 	ping -c 1 ${IP}  && echo -e "${green}${IP}连接通畅${end}"|| echo -e "${red}${IP}连接断开${end}"	
 }

 q6() {
 	#检测内存使用率
 	t=`free -h | grep "Mem" | awk -F " " '{print $2}'`
 	u=`free -h | grep "Mem" | awk -F " " '{print $3}'`
 	f=`free -h | grep "Mem" | awk -F " " '{print $4}'`
 	s=`free -h | grep "Mem" | awk -F " " '{print $5}'`
 	b=`free -h | grep "Mem" | awk -F " " '{print $6}'`
 	a=`free -h | grep "Mem" | awk -F " " '{print $7}'`
 	echo -e "内存一共有:		${green}${t}${end}"
 	echo -e "使用了:			${green}${u}${end}"
 	echo -e "物理空闲:		${green}${f}${end}"
 	echo -e "共享内存:		${green}${s}${end}"
 	echo -e "硬盘缓存:		${green}${b}${end}"
 	echo -e "可使用内存（不准确）:	${green}${a}${end}"
 }

while [ 1 ];do
	clear
	echo -e "
*************************************************
*1.计算目录下文件夹,文件的功能                  *
*2.计算从0到你输入的数字之和                    *
*3.创建用户                                     *
*4.检测用户密码是否正确                         *
*5.检测网络连通性                               *
*6.检测内存使用率                               *
*7.数据库里查询学生成绩                         *
*q.退出程序                                     *
*************************************************
"
read -p "请输入要选择的功能：" key
case ${key} in
	1)
 	q1
	read -p "请按回车继续"
	;;
	2)
 	q2
	read -p "请按回车继续"
	;;
	3)
 	q3
	read -p "请按回车继续"
	;;
	4)
 	echo -e "\033[1;31m未完成，请重新选择\033[0m"
	read -p "请按回车继续"
	;;
	5)
 	q5
	read -p "请按回车继续"
	;;
	6)
 	q6
	read -p "请按回车继续"
	;;
	7)
 	echo -e "\033[1;31m未完成，请重新选择\033[0m"
	read -p "请按回车继续"
	;;
	q)
 	break
	;;
	*)
 	echo "请重新输入"
	read -p "请按回车继续"
	;;
esac
done