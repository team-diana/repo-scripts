#!/usr/bin/env bash

# Copyright (c) 2015 Team DIANA, http://www.teamdiana.org
#
# This file is license under the MIT license, see LICENSE file for further
# details.
#

# Variables
export script_home="`pwd`"
export script_name="repo.sh"
export script_version="0.2.0"

export SCRIPTS="`pwd`/scripts"
export DOCS="$SCRIPTS/docs"

export LOG="`pwd`/build.log"
export BUILD_CLEAN=0

# Allow user to set a different build location
RESET_BASE=1
if [ ! -e "$BASE" ]; then
	RESET_BASE=0
	export BASE="/tmp/build"
fi

source "$DOCS/copyright.sh"

# Parse the options
OPTSTRING=ch:
while getopts ${OPTSTRING} OPT; do
	case ${OPT} in
		c|-clean) rm -rfv "$BASE" >> "$LOG" 2>&1 ;;
		h|-help) "$DOCS/usage.sh"; exit 0 ;;
		*) "$DOCS/usage.sh"; exit 1 ;;
	esac
done
shift "$(( $OPTIND - 1 ))"

source "$SCRIPTS/common.sh"

# Check we are running on a supported system in the correct way.
check_root
check_sudo

export BUILD_DEPS="cdbs libbz2-dev zlib1g-dev python-dev"

source "$SCRIPTS/create_build_dirs.sh"
source "$SCRIPTS/install_build_deps.sh"

for p in $packages; do
	export package_name=$p

	source "$SCRIPTS/pkgs/get_$package_name.sh"
	source "$SCRIPTS/pkgs/make_build_scripts_$package_name.sh"
	source "$SCRIPTS/build_packages.sh"
done

source "$SCRIPTS/create_repository.sh"

source "$SCRIPTS/sign_packages.sh"

# unset global variables
echo "unsetting variables..." >> "$LOG"
unset script_home
unset script_name
unset script_version

unset SCRIPTS
unset DOCS

unset LOG
unset BUILD_CLEAN

if [ $RESET_BASE == 1]; then
	unset BASE
fi

unset package_name
unset BUILD_DEPS

echo
echo "All done!"
