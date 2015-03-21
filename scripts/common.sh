# This code is based on code by Martin Wimpress, http://flexion.org/ released
# under an MIT license, see LICENSE file for further details.

function error_msg() {
	echo -e "\033[0;31m ERROR:\033[0m $1"
	echo "ERROR: $1" >> "$LOG"
	exit 1
}

function cecho() {
	echo -e "$1"
	echo -e "$1" >>"$LOG"
	tput sgr0;
}

function ncecho() {
	echo -ne "$1"
	echo -ne "$1" >>"$LOG"
	tput sgr0
}

function spinny() {
	sp="/-\|"
	echo -ne "\b${sp:i++%${#sp}:1}"
}

function progress() {
	ncecho "  ";
	while [ /bin/true ]; do
		kill -0 $pid 2>/dev/null;
		if [[ $? = "0" ]]; then
			spinny
			sleep 0.25
		else
			ncecho "\b\b";
			wait $pid
			retcode=$?
			echo "$pid's retcode: $retcode" >> "$LOG"
			if [[ $retcode = "0" ]] || [[ $retcode = "255" ]]; then
				cecho "[\033[0;32msuccess\033[0m]"
			else
				cecho "[\033[0;31mfailed\033[0m]"
				echo -e " [i] Showing the last 5 lines from the logfile ($LOG)...";
				tail -n5 "$LOG"
				exit 1;
			fi
			break;
		fi
	done
}

function check_root() {
	if [ "$(id -u)" != "0" ]; then
		error_msg "You must execute the script as the 'root' user."
	fi
}

function check_sudo() {
	if [ ! -n ${SUDO_USER} ]; then
		error_msg "You must invoke the script using 'sudo'."
	fi
}

function lsb() {
	local CMD_LSB_RELEASE=`which lsb_release`
	if [ "${CMD_LSB_RELEASE}" == "" ]; then
		error_msg "'lsb_release' was not found. Distribution couldn't be identified, are you sure you are running a Debian-based system?"
	fi
	LSB_ID=`lsb_release -i | cut -f2 | sed 's/ //g'`
	LSB_REL=`lsb_release -r | cut -f2 | sed 's/ //g'`
	LSB_CODE=`lsb_release -c | cut -f2 | sed 's/ //g'`
	LSB_DESC=`lsb_release -d | cut -f2`
	LSB_ARCH=`dpkg --print-architecture`
	LSB_MACH=`uname -m`
	LSB_NUM=`echo ${LSB_REL} | sed s'/\.//g'`
}
