source "$SCRIPTS/common.sh"

# Make sure the required dirs exist.
ncecho " [x] Making build directories "
mkdir -p "$BASE/deb" >> "$LOG" 2>&1 &
mkdir -p "$BASE/gpg" >> "$LOG" 2>&1 &
mkdir -p "$BASE/pkg" >> "$LOG" 2>&1 &
pid=$!;progress $pid

# Set the permissions appropriately for 'gpg'
chown root:root "$BASE/gpg" >> "$LOG" 2>&1
chmod 0700 "$BASE/gpg" >> "$LOG" 2>&1
