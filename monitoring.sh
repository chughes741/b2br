#! /bin/bash

# Broadcast message with sysinfo


# General info
TIME=$(date)
BOOT_last=
LVM_on=
USERS_active=
SUDO_count=

# Hardware info
ARC=

CPU_p=
CPU_v=
CPU_load=

MEM_total=$(free -m | grep -i "mem" | awk {print $2})
MEM_use=$(free -m | grep -i "mem" | awk {print $3})
let "MEM_perc = ($MEM_use / $MEM_total) * 100"

DISK_total=$()
DISK_use=$()
let "DISK_perc = ($DISK_use / $DISK_total) * 100"


# Network
TCP_active=$(wc -l /proc/net/tcp)
IP4_address=$(hostname -I)

# Print banner
printf "%s    %s\n" "Broadcast from: root@chughes" "$TIME"
printf "\t%-20s %s\n" "Architecture:" "$ARC"
printf "\t%-20s %s\n" "pCPU:" "$CPU_p"
printf "\t%-20s %s\n" "vCPU:" "$CPU_v"
printf "\t%-20s %s %s/%sMB %.2s\n" "Memory:" "$MEM_use""$MEM_total" "$MEM_perc"
printf "\t%-20s %s %s/%sGB %.2s\n" "Disk:" "$DISK_use" "$DISK_total" "$DISC_perc"
printf "\t%-20s %s\n" "CPU Load:" "$CPU_load"
printf "\t%-20s %s\n" "Last Boot:" "$BOOT_last"
printf "\t%-20s %s\n" "LVM Active:" "$LVM_on"
printf "\t%-20s %s\n" "TCP Connections:" "$TCP_active"
printf "\t%-20s %s\n" "Active Users:" "$USERS_active"
printf "\t%-20s %s\n" "IPv4 Address:" "$IP4_address"
printf "\t%-20s %s\n" "sudo use:" "$SUDO_count"
