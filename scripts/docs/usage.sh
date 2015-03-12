#!/usr/bin/env bash

if [[ "$DOCS" == "" ]]; then
    DOCS="."
fi

source "$DOCS/common.sh" "$1"
source "$SCRIPTS/common.sh"
lsb

NAME="repo.sh"

header "Usage"
echo
code "sudo ./$NAME"
echo
subheader "Optional parameters"
point "`partial_code "-c | --clean"` : Builds new packages from scratch and removes everything from the repository."
point "`partial_code "-h | --help"` : This help message"
echo
header "How to use generated repository?"
echo "Like so:"
echo
code "curl http://www.teamdiana.org/apt.key | sudo apt-key add -"
code "sudo echo \"deb http://www.teamdiana.org/repositories/ ${LSB_CODE} main\" > /etc/apt/sources.d/team-diana.list"
code "sudo apt-get update"
echo
echo "Then you can install packages provided by the repository by issuing:"
code "sudo apt-get install <package-name>"
echo "eg"
code "sudo apt-get install boost-all"
echo
