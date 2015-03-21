source "$SCRIPTS/common.sh"
lsb

cd "$BASE/$package_name/src"

# Build the binary packages
ncecho " [x] $package_name: Building the packages "
dpkg-buildpackage -b -us -uc -j4 >> "$LOG" 2>&1 &
pid=$!;progress $pid

for dist in ${build_for}; do
	pushd "$script_home" >> "$LOG"
	DEBVERSION="${PKG_VERSION}~${dist}-`git rev-parse --short HEAD`"
	popd >> "$LOG"

	CHANGES="$BASE/$package_name/${DEBNAME}_${DEBVERSION}_${LSB_ARCH}.changes"

	if [ -e "$CHANGES" ]; then
	    # Populate the 'apt' repository with .debs
	    ncecho " [x] $package_name: Moving the packages "
	    mv -v "$CHANGES" "$BASE/deb/" >> "$LOG" 2>&1
	    mv -v "$BASE/$package_name/"*".deb" "$BASE/deb/" >> "$LOG" 2>&1 &
	    pid=$!;progress $pid
	else
	    error_msg "Packages failed to build."
	    exit 1
	fi
done

# These *MUST BE* exported in a package's make_build_scripts_${package_name}.sh
unset DEBNAME
unset PKG_VERSION
