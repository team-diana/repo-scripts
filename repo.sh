#!/usr/bin/env bash

# Copyright (c) 2015 Team DIANA, http://www.teamdiana.org
#
# This file is license under the MIT license, see LICENSE file for further
# details.
#

# Variables
export SCRIPTS="`pwd`/scripts"
export DOCS="$SCRIPTS/docs"

export LOG="`pwd`/build.log"
export BUILD_CLEAN=0
export BASE="/tmp/build"

"$DOCS/copyright.sh"

# Parse the options
OPTSTRING=ch:
while getopts ${OPTSTRING} OPT
do
    case ${OPT} in
        c|-clean) rm -rf "$BASE";;
        h|-help)
          "$DOCS/usage.sh"
          exit 0
        ;;
        *)
          "$DOCS/usage.sh"
          exit 1
        ;;
    esac
done
shift "$(( $OPTIND - 1 ))"

source "$SCRIPTS/common.sh"

# Check we are running on a supported system in the correct way.
#check_root
#check_sudo

export package_name="boost"
export BUILD_DEPS="cdbs libbz2-dev zlib1g-dev python-dev"
export build_for="precise trusty utopic"

"$SCRIPTS/install_build_deps.sh"
"$SCRIPTS/create_build_dirs.sh"

"$SCRIPTS/pkgs/get_$package_name.sh"
"$SCRIPTS/pkgs/make_build_scripts_$package_name.sh"

"$SCRIPTS/build_packages.sh"

"$SCRIPTS/create_repository.sh"

"$SCRIPTS/sign_packages.sh"

# Update apt cache
#echo "deb file://$BASE/deb /" #> /etc/apt/sources.list.d/oab.list
#apt_update


# unset global variables
echo "unsetting variables..." >> "$LOG"
unset SCRIPTS
unset DOCS
unset BASE
unset LOG
unset BUILD_CLEAN
unset package_name
unset BUILD_DEPS
unset build_for

echo "All done!"
