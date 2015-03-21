source "$SCRIPTS/common.sh"
lsb

echo "Usage"
echo "====="
echo
echo "  sudo ${script_home}/${script_name} [-c|--clean|-h|--help]"
echo
echo "Optional parameters"
echo "==================="
echo
echo "-c:	Builds new packages from scratch and removes everything from the repository."
echo
echo "-h:	This help message."
echo
echo "How to use generated repository?"
echo "================================"
echo "Like so:"
echo
echo "  curl https://www.tamersaadeh.com/diana/deb/pubkey.asc | sudo apt-key add -"
echo "  sudo sh -c 'echo \"deb http://www.tamersaadeh.com/diana/deb/ all main\" > /etc/apt/sources.d/team-diana.list'"
echo "  sudo apt-get update"
echo
echo "Then you can install packages provided by the repository by issuing:"
echo "  sudo apt-get install <package-name>"
echo "eg"
echo "  sudo apt-get install boost-all"
echo
