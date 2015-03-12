#!/usr/bin/env bash

# Copyright (c) 2015 Team DIANA, http://www.teamdiana.org
#
# This file is license under the MIT license, see LICENSE file for further
# details.
#
# References
#  - https://github.com/rraptorr/sun-java6
#  - https://github.com/rraptorr/oracle-java7
#  - https://github.com/flexiondotorg/oab-java6
#  - http://ubuntuforums.org/showthread.php?t=1090731
#  - http://irtfweb.ifa.hawaii.edu/~lockhart/gpg/gpg-cs.html

# Variables
export SCRIPTS="`pwd`/scripts"
export DOCS="$SCRIPTS/docs"

export LOG="`pwd`/build.log"
export BUILD_KEY=""
export BUILD_CLEAN=0
export BASE="/tmp/build"

"$DOCS/copyright.sh"

# Parse the options
OPTSTRING=bchk:
while getopts ${OPTSTRING} OPT
do
    case ${OPT} in
        b|-build-docs)
          "$DOCS/build.sh" "`pwd`"
          exit 0
        ;;
        c|-clean) BUILD_CLEAN=1;;
        h|-help)
          "$DOCS/usage.sh"
          exit 0
        ;;
        k) BUILD_KEY=${OPTARG};;
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
export BUILD_DEPS="cdbs libbz2-dev zlib1g-dev"

"$SCRIPTS/install_build_deps.sh"
"$SCRIPTS/create_build_dirs.sh"

"$SCRIPTS/pkgs/get_$package_name.sh"
"$SCRIPTS/pkgs/make_build_scripts_$package_name.sh"

"$SCRIPTS/build_packages.sh"

"$SCRIPTS/create_repository.sh"

"$SCRIPTS/sign_packages.sh"

# Update apt cache
echo "deb file://$BASE/deb /" #> /etc/apt/sources.list.d/oab.list
#apt_update

# remove download index and download release page
echo "removing extra files..." >> "$LOG"
rm -rf /tmp/oab-index.html
rm -rf /tmp/oab-download.html

# unset global variables
echo "unsetting variables..." >> "$LOG"
unset SCRIPTS
unset DOCS
unset BASE
unset LOG
unset BUILD_KEY
unset BUILD_CLEAN

echo "All done!"
