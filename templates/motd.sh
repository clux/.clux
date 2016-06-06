#!/bin/bash
PATH=/sbin:/usr/games:/usr/local/node/bin:$PATH

cpu5=$(awk '{printf("%3.1f%%", $2*100/'"$(nproc)"') }' < /proc/loadavg)

iface=$(ip link show | grep enp | awk '{print $2}' | cut -d':' -f1)
netdata=$(ip -s link show "$iface" | awk -v ORS=" " '{ print $1 }')
RECV=$(echo "$netdata" | cut -d" " -f4 | awk '{printf("%3.1fGB\n", $1/1073741824)}')
SENT=$(echo "$netdata" | cut -d" " -f6 | awk '{printf("%3.1fGB\n", $1/1073741824)}')

KERNEL=$(uname -r)
CPU=$(awk -F '[ :][ :]+' '/^model name/ { print $2; exit; }' /proc/cpuinfo)

disk=$(df -l --total | grep total | awk '{printf("%3.1f%%", $3*100/$2)}')
swap=$(free -m | tail -n 1 | awk '{print $3}')

# Memory
#meminuse=$(free -t -m | grep "buffers/cache" | awk '{print $3" MB";}')
memtotal=$(free -t -m | grep "Mem" | awk '{print $2" MB";}')
memusage=$(free -t | grep Mem | awk '{ printf("%3.1f%%", $3*100/$2)}')

# Processes
#PSA=$(ps -Afl | wc -l)
#PSU=$(ps U $USER h | wc -l)

if pgrep PM2 > /dev/null; then
  pm2total=$(pm2 jlist | json -a pm2_env.status | wc -l)
  pm2online=$(pm2 jlist | json -a pm2_env.status | grep -c online)
fi

#System uptime
uptime=$(cut -f1 -d. < /proc/uptime)
upDays=$((uptime/60/60/24))
upHours=$((uptime/60/60%24))
upMins=$((uptime/60%60))
upSecs=$((uptime%60))

#Color variables
W="\033[00;37m" # white
B="\033[01;36m" # cyan
R="\033[01;34m" # blue
X="\033[01;37m" # reset
A="\033[01;31m" # red
Z="\033[01;33m" # yellow

# Color code high numbers
if [[ $memusage > 80 ]]; then
  memusage="${A}${memusage}${W}"
elif [[ $memusage > 40 ]]; then
  memusage="${Z}${memusage}${W}"
fi
if [[ $cpu5 > 80 ]]; then
  cpu5="${A}${cpu5}${W}"
elif [[ $cpu5 > 40 ]]; then
  cpu5="${Z}${cpu5}${W}"
fi
if [[ $disk > 90 ]]; then
  disk="${A}${disk}${W}"
elif [[ $disk > 75 ]]; then
  disk="${Z}${disk}${W}"
fi

echo -e "$(hostname)\n$(lsb_release -si) $(lsb_release -sr)" | cowsay -n -f eyes | lolcat
echo -e "$R======================================================="
echo -e "  $R KERNEL$W   $KERNEL"
echo -e "  $R CPU$W      $CPU"
echo -e "  $R USERS$W    Currently $(users | wc -w) users logged on"
echo -e "$R======================================================="
echo -e "  $R Load$W     $cpu5 (5 min)"
echo -e "  $R Memory$W   ${memusage} of $memtotal"
if [ "$swap" -ne 0 ]; then
echo -e "  $R Swap$W    $swap MB"
fi
if [[ $pm2total -ne 0 ]]; then
echo -e "  $R Jobs$W    $pm2online online out of $pm2total total"
fi
#echo -e "  $R Processes$W You run $PSU out of $PSA total processes"
if [ "$RECV" != "0.0GB" ]; then
echo -e "  $R Network$W  RX $RECV $B-$W TX $SENT"
fi
echo -e "  $R Uptime$W   $upDays days $upHours hours $upMins minutes $upSecs seconds"
echo -e "  $R Disk$W     $disk"
echo -e "$R=======================================================$X"
