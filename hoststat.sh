#!/bin/bash

#颜色
 GREEN="\033[1;32m"
 RED="\033[0;31m"
 RESET="\033[0m"
#本脚本的主要功能为针对部分linux虚拟机在长时间待机后偶发性的异常卡顿严重的问题提供可能的解决思路,更多详细信息请访问系统日志做进一步排查
  printf "请检查您的虚拟机软件版本为最新版本，以排除可能存在的兼容性问题\nPlease ensure that your Virtual machine software is the latest version,  in account of possible capatibility issues\n"
  echo -e "\n${GREEN}--------------------------------------------------${RESET}"

#本次登录的相关信息
IPADDR=$(hostname -I | awk '{print $1}')
LOADAVG=$(uptime | awk -F 'load average: ' '{print $2}' | sed 's/^ //')
UPTIME=$(uptime -p | sed 's/up //')
echo -e "欢迎使用本脚本，以下是您本次登录的部分信息:\n"
printf "| %-10s | %-30s |\n" "IP地址    " "$IPADDR"
printf "| %-10s | %-30s |\n" "平均负载  " "$LOADAVG"
printf "| %-10s | %-30s |\n" "运行时长  " "$UPTIME"
echo -e "\n${GREEN}---------------------------------------------------${RESET}"

#检查是否存在内存不足的问题
  check_swap=$(swapon --show)
  size=$(echo "$check_swap" | awk 'NR=2{print $3}')
  used=$(echo "$check_swap" | awk 'NR==2{print $4}')
  #检查交换区
  echo
  #检查实际占用内存
  check_memory=$(free -m)
  total_memory=$(echo "$check_memory" | awk 'NR==2{print $2}')
  free_memory=$(echo "$check_memory" | awk 'NR==2{print $4}')
  used_memory=$(echo "$check_memory" | awk 'NR==2{print $3}')
  share_memory_and_buffer_cache=$(echo "$check_memory" | awk 'NR==2{print $5, $6}')
 
  threshold_mem=256 #规定1024MB为内存阈值
  echo -e "总内存：$total_memory MB\n" 
  echo -e "已占用: $used_memory MB\n"
  echo -e "可用内存: $free_memory MB\n"
  echo -e "共享内容与缓冲/缓存内容: $share_memory_and_buffer_cache MB\n"

  if [ "$free_memory" -lt "$threshold_mem" ]; then
	  echo -e "${RED}当前剩余存储空间不足256MB，建议释放部分内存或优化您的虚拟机内存分配${RESET}"
  fi
echo -e "\n${GREEN}---------------------------------------------------${RESET}"


threshold_ps=5

#以下部分为排查异常的高cpu占用进程

ps -eo pid,comm,%mem,%cpu --sort=-%cpu | awk -v threshold=$threshold_ps 'NR>1 && $4+0 > threshold {print $1 " " $2 " " $3 " " $4}' | 
	while read pid comm mem cpu;
do
	echo -e "${RED}进程 $comm (PID: $pid) CPU占用 $cpu% 高于阈值 $threshold_ps%${RESET}"
	read -p "是否终止进程 $comm (PID: $pid)?[y/n]: " user_input </dev/tty
	#显示指定从当前终端读取输入，为了避开前面多条命令并行导致的管道占用
	if [[ "$user_input" == "y" || "$user_input" == "Y" ]]; then
		kill $pid 
                echo -e "\n${GREEN}------------------------------------${RESET}"
	elif [[ "$user_input" == "n" || "$user_input" == "N" ]]; then
		echo "放弃"
	else 
		echo "无效输入，请重新输入"
        fi
done

#检查是否存在内核问题
if journalctl -p 3 -xb | grep -Ei "Kernal panic|Kernal BUG|kernel warning" ; then
  #只关注本次启动中日志是否存在内核错误或警告
	echo -e "${RED}系统存在内核问题，请访问日志进一步排查${RESET}"
fi
