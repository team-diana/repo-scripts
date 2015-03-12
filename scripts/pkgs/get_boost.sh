source "$SCRIPTS/common.sh"
lsb

ncecho " [x] $package_name: Getting sources "
 wget "http://downloads.sourceforge.net/project/boost/boost/1.57.0/boost_1_57_0.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fboost%2Ffiles%2Fboost%2F1.57.0%2F&ts=1385240128&use_mirror=switch" -O $BASE/$package_name/boost-all_1.57.0.orig.tar.bz2 >> "$LOG" 2>&1 &
pid=$!;progress $pid

export DEBVERSION=1.57.0~${LSB_CODE}1

ncecho " [x] $package_name: Processing sources "

cd /tmp
tar xvjf boost-all_1.57.0.orig.tar.bz2 2>&1 &
pid=$!;progress $pid

mv /tmp/boost_1_57_0/* $BASE/$package_name/src/
rm -rf $BASE/$package_name/src/debian
