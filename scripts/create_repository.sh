source "$SCRIPTS/common.sh"
lsb

ncecho " [x] Generation of repostory priorities list "
# Create a temporary 'override' file, which may contain duplicates
echo "# Override" > /tmp/override
echo "# Package priority section" >> /tmp/override
for FILE in "$BASE/deb/dists/all/main/binary-amd64/"*".deb"
do
	DEB_PACKAGE=`dpkg --info ${FILE} | grep Package | cut -d':' -f2`
	DEB_SECTION=`dpkg --info ${FILE} | grep Section | cut -d'/' -f2`
	echo "${DEB_PACKAGE} high ${DEB_SECTION}" >> /tmp/override
done >> "$LOG" 2>&1 &
pid=$!;progress $pid

# Remove the duplicates from the overide file
uniq /tmp/override > "$BASE/deb/override"
rm -rfv /tmp/override >> "$LOG" 2>&1

# Create the apt.conf file
ncecho " [x] Generation of $BASE/apt.conf configuration file "
echo "APT::FTPArchive::Release {"		> "$BASE/apt.conf"
echo "Origin \"tamersaadeh.com\";"		>> "$BASE/apt.conf"
echo "Label \"C, C++, libs\";"			>> "$BASE/apt.conf"
echo "Suite \"${LSB_CODE}\";"                   >> "$BASE/apt.conf"
echo "Codename \"${LSB_CODE}\";"                >> "$BASE/apt.conf"
echo "Architectures \"${LSB_ARCH}\";"           >> "$BASE/apt.conf"
echo "Components \"main\";"			>> "$BASE/apt.conf"
echo "Description \"Team DIANA Repository\";"   >> "$BASE/apt.conf"
echo "}"					>> "$BASE/apt.conf" &
pid=$!;progress $pid

# Create the 'apt' Packages.gz file
ncecho " [x] Creating $BASE/deb/dists/all/main/binary-amd64/Packages.gz file "

pushd "$BASE/deb" >> "$LOG"
apt-ftparchive -c="$BASE/apt.conf" packages . "$BASE/deb/override" 2>/dev/null > "$BASE/deb/dists/all/main/binary-amd64/Packages" &
pid=$!;progress $pid
popd >> "$LOG"

cat "$BASE/deb/dists/all/main/binary-amd64/Packages" | gzip -c9 > "$BASE/deb/dists/all/main/binary-amd64/Packages.gz"
rm -v "$BASE/deb/override" >> "$LOG" 2>&1

# Create the 'apt' Release file
ncecho " [x] Creating $BASE/deb/dists/all/Release file "
apt-ftparchive -c="$BASE/apt.conf" release "$BASE/deb/"	> "$BASE/deb/dists/all/Release" &
pid=$!;progress $pid

# Create the 'apt' Contents file
ncecho " [x] Creating $BASE/deb/dists/all/main/binary-amd64/Contents file "
apt-ftparchive -c="$BASE/apt.conf" contents "$BASE/deb/" > "$BASE/deb/dists/all/main/binary-amd64/Contents" &
pid=$!;progress $pid
