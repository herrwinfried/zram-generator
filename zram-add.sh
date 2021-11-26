#!/bin/bash
function countdown_10_seconds {
    echo "Countdown will begin (10 seconds)"
    sleep 10
}

value=$1
type=$2

if [[ -z $value ]] || [[ -z $type ]]; then
echo "first or second value is empty. It cannot be left blank. The operation is being cancelled." 
countdown_10_seconds
exit 1
fi 
if [[ ! $value =~ ^[0-9]+$ ]]; then
echo "Incorrect Usage: You can only enter Numbers." 
countdown_10_seconds
exit 1
fi



if [[ ! $type =~ ^[a-zA-Z]+$ ]]; then
echo "Incorrect Usage: You can only enter string expressions."
countdown_10_seconds
exit 1
fi

if [[ $EUID -ne 0 ]]; then
     echo "$red You need to be Super User/Root. $white" 
	 countdown_10_seconds
   exit 1
fi

if [[ ! -x /run/systemd/system ]]; then
echo "this script is for systemd users only."
exit 1
else 
echo "Important Notice This Script is for experimentally running zram on Systemd. I do not accept any responsibility."
countdown_10_seconds
fi

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

echo "such a value already exists. I will not change."

fi

fi

echo "KERNEL=="zram0", ATTR{disksize}="$value$type", TAG+="systemd"" > /etc/udev/rules.d/99-zram.rules

if [[ -x /run/systemd/system ]]; then

		touch /etc/systemd/system/zram-manuel.service
		echo "[Unit]
		Description=zram service.
		After=multi-user.target
		[Service]
		Type=oneshot
		RemainAfterExit=true
		ExecStartPre=/sbin/mkswap /dev/zram0
		ExecStart=/sbin/swapon /dev/zram0 --priority 100
		ExecStop=/sbin/swapoff /dev/zram0
		[Install]
		WantedBy=multi-user.target" > /etc/systemd/system/zram-manuel.service
		sudo systemctl enable zram-manuel
        sudo systemctl start zram-manuel
echo "Restart your computer."
sleep 2
else 
echo "I couldn't create a service"
countdown_10_seconds
fi