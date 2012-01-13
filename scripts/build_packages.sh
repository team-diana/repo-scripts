source "$SCRIPTS/common.sh"
lsb

cd $BASE/$package_name/src

# Build the binary packages
ncecho " [x] $package_name: Building the packages "
dpkg-buildpackage -b >> "$LOG" 2>&1 &
pid=$!;progress_can_fail $pid

if [ -e "$BASE/$package_name/src/$1_${DEBVERSION}_${LSB_ARCH}.changes" ]; then
    # Populate the 'apt' repository with .debs
    ncecho " [x] $package_name: Moving the packages "
    mv -v "$BASE/$package_name/src/$1_${DEBVERSION}_${LSB_ARCH}.changes" "$BASE/deb/" >> "$LOG" 2>&1
    mv -v "$BASE/$package_name/src/"*".deb" "$BASE/deb/" >> "$LOG" 2>&1 &
    pid=$!;progress $pid
else    
    error_msg "ERROR! Packages failed to build."
fi
