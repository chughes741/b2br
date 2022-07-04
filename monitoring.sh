#! /bin/bash

# Broadcast message with sysinfo

# Time since last boot in minutes and seconds
BOOT_m=$(uptime -s | cut -d ":" -f 2)
BOOT_s=$(uptime -s | cut -d ":" -f 3)

# Sets delay so script runs exactly 10 minutes after booting
DELAY=$(bc <<< $BOOT_m%10*60+$BOOT_s)
sleep $DELAY

# General info
TIME=$(date)
BOOT_last=$(who -b | awk '{NR==1} END {print $3" "$4}')
LVM_on=$(lsblk | awk '{if ($6 = "lvm") {print "active";exit} else print "inactive";exit}')
USERS_active=$(who | wc -l)
SUDO_count=$(cat /var/log/sudo/log | grep 'COMMAND' | wc -l)

# Hardware info
ARC=$(uname -a)

CPU_p=$(lscpu | grep 'Socket' | awk '{print $2}')
CPU_v=$(lscpu | grep -m 1 'CPU(s)' | awk '{print $2'})
CPU_load=$(vmstat | 'NR==3 {printf("%.2f %%\n"), 100 - $15}')

MEM_total=$(free -m | grep -i "mem" | awk '{print $2}')
MEM_use=$(free -m | grep -i "mem" | awk '{print $3}')
MEM_perc=$(free -m | grep 'Mem' | awk '{used += $3} {tot += $2} END {printf("%.2f"), used/tot*100}')

DISK_total=$(df -Bm | grep ^/dev/ | awk '{tot += $2} END {print tot}')
DISK_use=$(df -Bm | grep ^/dev/ | awk '{used += $3} END {print used}')
DISK_perc=$(df -Bm | grep ^/dev/ | awk '{tot += $2} {used += $3} END {printf("%.2f"), used/tot*100}')


# Network
TCP_active=$(wc -l /proc/net/tcp)
IP4_address=$(hostname -I)

# Print banner
printf "%s    %s\n\n" "Broadcast from: root@chughes" "$TIME"
printf "\t%-20s %s\n" "Architecture:" "$ARC"
printf "\t%-20s %s\n" "pCPU:" "$CPU_p"
printf "\t%-20s %s\n" "vCPU:" "$CPU_v"
printf "\t%-20s %s/%s MB (%s%%)\n" "Memory:" "$MEM_use" "$MEM_total" "$MEM_perc"
printf "\t%-20s %s/%s GB (%s%%)\n" "Disk:" "$DISK_use" "$DISK_total" "$DISK_perc"
printf "\t%-20s %s\n" "CPU Load:" "$CPU_load"
printf "\t%-20s %s\n" "Last Boot:" "$BOOT_last"
printf "\t%-20s %s\n" "LVM Active:" "$LVM_on"
printf "\t%-20s %s\n" "TCP Connections:" "$TCP_active"
printf "\t%-20s %s\n" "Active Users:" "$USERS_active"
printf "\t%-20s %s\n" "IPv4 Address:" "$IP4_address"
printf "\t%-20s %s\n" "sudo use:" "$SUDO_count"
