#!/bin/bash

function color_sh {
termcols=$(tput cols)
bold="$(tput bold)"
fontnormal="$(tput init)"
fontreset="$(tput reset)"
underline="$(tput smul)"
standout="$(tput smso)"
normal="$(tput sgr0)"
black="$(tput setaf 0)"
red="$(tput setaf 1)"
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"
blue="$(tput setaf 4)"
magenta="$(tput setaf 5)"
cyan="$(tput setaf 6)"
white="$(tput setaf 7)"
}

function wslcheck(){
unameout=$(uname -r | tr '[:upper:]' '[:lower:]');
if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" == "0xffffffff" ]; then
echo "$yellow""I guess you are not using Desktop.""$red""The transaction has been cancelled." $white
exit 1
fi
}

color_sh


function countdown_10_seconds {
    echo "$cyan""Countdown will begin (10 seconds)"
    sleep 10
}

value=$1
type=$2 
#type="$(echo $type | tr '[:upper:]' '[:lower:]')"

if [[ $value == "-h" ]] || [[ $value == "--help" ]]; then
echo -e "
$magenta""first argument
	$green""Zram Amount							"$yellow"numeric value for example: 500
$magenta""second argument
	$green""Type								"$yellow"Write one of these three values GiB,MiB,Kib
$blue""Example $cyan
sudo ./zram-script 500 MiB $white

	"
	exit 1
fi

if [[ -z $value ]] || [[ -z $type ]]; then
echo "$red""first or second value is empty. It cannot be left blank. The operation is being cancelled." 
countdown_10_seconds
exit 1
fi 
if [[ ! $value =~ ^[0-9]+$ ]]; then
echo "$red""Incorrect Usage:$green"" You can only enter Numbers." 
countdown_10_seconds
exit 1
fi

if [[ ! $type == "KiB" ]] && [[ ! $type == "MiB" ]] && [[ ! $type == "GiB" ]]; then 
echo "$red""Incorrect Usage:$green"" The format is currently not supported except GiB, MiB, KiB."
countdown_10_seconds
exit 1
fi


if [[ ! $type =~ ^[a-zA-Z]+$ ]]; then
echo "$red""Incorrect Usage:$green"" You can only enter string expressions."
countdown_10_seconds
exit 1
fi

if [[ $EUID -ne 0 ]]; then
     echo "$red""You need to be Super User/Root. $white" 
	 countdown_10_seconds
   exit 1
fi

echo VALUE: $value
echo TYPE: $type

if [[ -x /run/systemd/system ]]; then
echo "$yellow""Important Notice This Script is for experimentally running zram on Systemd. I do not accept any responsibility. $white"
countdown_10_seconds


if [[ ! -f "/etc/modules-load.d/zram.conf" ]]; then
	touch /etc/modules-load.d/zram.conf
fi

echo "zram" > /etc/modules-load.d/zram.conf

if [[ ! -f "/etc/modprobe.d/zram.conf" ]]; then
		touch /etc/modprobe.d/zram.conf
fi

echo "options zram num_devices=1" > /etc/modprobe.d/zram.conf

if [[ ! -f "/etc/udev/rules.d/99-zram.rules" ]]; then
		touch /etc/udev/rules.d/99-zram.rules
fi

if [[ -f "/etc/udev/rules.d/99-zram.rules" ]]; then
if [[ "$(grep "KERNEL==zram0, ATTR{disksize}=$value$type, TAG+=systemd" /etc/udev/rules.d/99-zram.rules)" ]]; then
echo "$yellow""such a value already exists. I will not change."
fi
else
echo "KERNEL=="zram0", ATTR{disksize}="$value$type", TAG+="systemd"" > /etc/udev/rules.d/99-zram.rules
fi

if [[ ! -f "/etc/systemd/system/zram-manuel-script.service" ]]; then
touch /etc/systemd/system/zram-manuel-script.service
fi

echo "[Unit]
		Description=zram service
		After=multi-user.target
		[Service]
		Type=oneshot
		RemainAfterExit=true
		ExecStartPre=/sbin/mkswap /dev/zram0
		ExecStart=/sbin/swapon /dev/zram0 --priority 100
		ExecStop=/sbin/swapoff /dev/zram0
		[Install]
		WantedBy=multi-user.target" > /etc/systemd/system/zram-manuel-script.service

sudo systemctl enable zram-manuel-script

echo "$magenta""Restart your computer. $white"
sleep 2
###################################################
else
echo "$red""this script is for systemd users only. $white"
exit 1
fi
