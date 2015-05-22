#! /bin/sh
### BEGIN INIT INFO
# Provides:          honeyPot
# Should-Start:      
# Required-Start:    $local_fs 
# Required-Stop:     $local_fs $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: honey pot for various services
# Description:       Debian init script for the HoneyPot
### END INIT INFO

# Default Root/mysql Password: honeypi
# Kippo mysql database: kippo / kippopi
# SSH port: ssh pi@IPADDRESS:65534
# SOFTWARE
#
# # Glastopf - Vulnerable web server
# # Dionaea - Low interaction malware trap
# # Honssh - High Interaction MiTM SSH Honeypot
# # Kippo - SSH Honeypot
# # Wordpot - Wordpress Honeypot
# # Ragpicker - Malware Crawler
# # Twisted Honeypots - Simple password collection python scripts w/ no shell
# https://www.digitalocean.com/community/articles/how-to-set-up-an-artillery-honeypot-on-an-ubuntu-vps


##################################################################
# MENU #
##################################################################
f_interface(){
clear
	echo "************************"
	echo " HoneyPI "
	echo "************************"
	echo "[1] Update Honeypi Programs"
	echo "[2] Run Programs"
	echo "[3] Change timezone"
	echo "[0] Exit"
	echo -n "Enter your menu choice [1-4]: "
	# wait for character input
	read -p "Choice:" menuchoice
		case $menuchoice in
			1) f_update ;;
			2) f_run ;;
			3) dpkg-reconfigure tzdata;;
			0) exit 0 ;;
			*) echo "Incorrect choice..." ;
		esac
}

##################################################################
# RUN MENU #
##################################################################

# =======================
# = UPDATE =
# =======================
f_update(){
cd /var/www/kippo-graph && git pull &&  chmod 777 generated-graphs
cd /opt/kippo-read-only && svn update
cd /opt/glastopf && git pull
cd /opt/honssh && git pull
cd /opt/wordpot && git pull
cd /opt/kippo-malware && git pull
cd /opt/twisted-honeypots && git pull
}


# =======================
# = RUNNING GLASTOPF =
# =======================
f_run_glastopf(){
service apache2 start
cd /opt/glastopfi && glastopf-runner
}
# =======================
# = RUNNING DIONAEA =
# =======================
f_run_dionaea(){
export PATH=$PATH:/opt/dionaea/bin
dionaea -l all,debug -r /opt/dionaea -w /opt/dionaea -p /opt/dionaea/var/dionaea.pid
}
# =======================
# = RUNNING RAGPICKER =
# =======================
f_run_ragpicker(){
python /opt/ragpicker/ragpicker.py -t 5 --log-filename=/opt/ragpicker/log.txt
}
# =======================
# = RUNNING HONSSH =
# =======================
f_run_honssh(){
cd /opt/honssh
 ./honsshctrl START
}
# =======================
# = RUNNING KIPPO =
# =======================
f_run_kippo(){
cd /opt/kippo-read-only
./start.sh
}
# =======================
# = BEING PROGRAM =
# =======================
if [ uid == "0" ];then
	f_interface
else
	echo "Get Root or Get Lost"
fi

