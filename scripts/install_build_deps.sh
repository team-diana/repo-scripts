source "$SCRIPTS/common.sh"
lsb

# Determine the build and runtime requirements.
COMMON_BUILD_DEPS="build-essential debhelper rng-tools imvirt"

ncecho " [x] Installing ${package_name} build requirements "
apt-get install -y --no-install-recommends ${COMMON_BUILD_DEPS} ${BUILD_DEPS} >> "$LOG" 2>&1 &
pid=$!;progress $pid
