source "$SCRIPTS/common.sh"

# Do we need to create signing keys
if [ ! -e "$BASE/gpg/pubring.gpg" ] && [ ! -e "$BASE/gpg/secring.gpg" ] && [ ! -e "$BASE/gpg/trustdb.gpg" ]; then
	ncecho " [x] Create GnuPG configuration "
	echo "Key-Type: RSA"				> "$BASE/gpg-key.conf"
	echo "Key-Length: 2048"				>> "$BASE/gpg-key.conf"
	echo "Subkey-Type: ELG-E"			>> "$BASE/gpg-key.conf"
	echo "Subkey-Length: 4096"			>> "$BASE/gpg-key.conf"
	echo "Name-Real: `hostname --fqdn` Key"		>> "$BASE/gpg-key.conf"
	echo "Name-Email: root@`hostname --fqdn`"	>> "$BASE/gpg-key.conf"
	echo "Expire-Date: 730"				>> "$BASE/gpg-key.conf" &
	pid=$!;progress $pid

	# Stop the system 'rngd'.
	/etc/init.d/rng-tools stop >> "$LOG" 2>&1

	ncecho " [x] Start generating entropy "
	rngd -r /dev/urandom -p /tmp/rngd.pid >> "$LOG" 2>&1 &
	pid=$!;progress $pid

	ncecho " [x] Creating signing key "
	gpg --homedir "$BASE/gpg" --batch --gen-key "$BASE/gpg-key.conf" >> "$LOG" 2>&1 &
	pid=$!;progress $pid

	ncecho " [x] Stop generating entropy "
	kill -9 `cat /tmp/rngd.pid` >> "$LOG" 2>&1 &
	pid=$!;progress $pid

	rm -v /tmp/rngd.pid >> "$LOG" 2>&1

	# Start the system 'rngd'.
	/etc/init.d/rng-tools start >> "$LOG" 2>&1
fi

# Do we have signing keys, if so use them.
if [ -e "$BASE/gpg/pubring.gpg" ] && [ -e "$BASE/gpg/secring.gpg" ] && [ -e "$BASE/gpg/trustdb.gpg" ]; then
	# Sign the Release
	ncecho " [x] Signing the 'Release' file "
	rm -v "$BASE/deb/Release.gpg" >> "$LOG" 2>&1
	gpg --homedir "$BASE/gpg" --armor --detach-sign --output "$BASE/deb/Release.gpg" "$BASE/deb/Release" >> "$LOG" 2>&1 &
	pid=$!;progress $pid

	# Export public signing key
	ncecho " [x] Exporting public key "
	gpg --homedir "$BASE/gpg" --export -a "`hostname --fqdn`" > "$BASE/deb/pubkey.asc" &
	pid=$!;progress $pid

	# Add the public signing key
	ncecho " [x] Adding public key "
	echo apt-key add "$BASE/deb/pubkey.asc" >> "$LOG" 2>&1 &
	pid=$!;progress $pid
fi
