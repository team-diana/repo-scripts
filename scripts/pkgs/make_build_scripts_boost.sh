# This code is based on code by Uli Köhler <ukoehler@btronik.de> released under
# a CC0 1.0 Universal, see LICENSE file for further details.

source "$SCRIPTS/common.sh"
lsb

# Epilogue vars
PKG_VERSION="1.57.0"
pushd "$script_home/scripts/pkgs" >> "$LOG"

if [ ! -f "${package_name}.vers" ]; then
	COUNTER=1
else
	COUNTER=$((`cat ${package_name}.vers`+1))
fi
echo "$COUNTER" > "${package_name}.vers"

export DEBNAME="${package_name}-all"
export DEBVERSION="${PKG_VERSION}-${COUNTER}~`git rev-parse --short HEAD`"

popd >> "$LOG"

ncecho " [x] $package_name: Preparing fake package "

cd "$BASE/$package_name/src"

# Build DEB
rm -rfv debian >> "$LOG"  2>&1
mkdir -p debian >> "$LOG" 2>&1

cat > debian/copying << EOF
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
EOF

# Create the changelog
dch --distribution "${LSB_CODE}" --force-distribution --create --newversion "${DEBVERSION}" --package "${DEBNAME}" "Automated build for Ubuntu. Built on `date +%Y-%m-%d` at `date +%H:%M:%S`." >> "$LOG" 2>&1 &
pid=$!;progress $pid

# Create control file
cat > debian/control << EOF
Source: boost-all
Maintainer: Team DIANA <info@teamdiana.org>
Section: misc
Priority: optional
Standards-Version: 3.9.2
Build-Depends: debhelper (>= 8), cdbs, libbz2-dev, zlib1g-dev, python-dev

Package: boost-all
Architecture: amd64
Depends: \${shlibs:Depends}, \${misc:Depends}, boost-all (= $DEBVERSION)
Description: Boost library, version $DEBVERSION (shared libraries)
Suggests: boost-all-dev (= $DEBVERSION)

Package: boost-all-dev
Architecture: any
Depends: boost-all (= $DEBVERSION)
Description: Boost library, version $DEBVERSION (development files)

Package: boost-build
Architecture: any
Depends: \${misc:Depends}
Description: Boost Build v2 executable
EOF

# Create rules file
cat > debian/rules << EOF
#!/usr/bin/make -f
%:
	dh \$@
override_dh_auto_configure:
	./bootstrap.sh --prefix="/opt/boost"
override_dh_auto_build:
	./b2 link=static,shared -j 4 --prefix="`pwd`/debian/boost-all/opt/boost/"
override_dh_auto_test:
override_dh_auto_install:
	mkdir -p debian/boost-all/opt/boost debian/boost-all-dev/opt/boost debian/boost-build/opt/boost/bin
	./b2 link=static,shared -j 4 --prefix="`pwd`/debian/boost-all/opt/boost/" install
	mv debian/boost-all/opt/boost/include debian/boost-all-dev/opt/boost/
	cp b2 debian/boost-build/opt/boost/bin
override_dh_shlibdeps:
	dh_shlibdeps -l"`pwd`/stage/lib"
EOF

# Create some misc files
echo "8" > debian/compat
mkdir -p debian/source >> "$LOG" 2>&1
echo "3.0 (quilt)" > debian/source/format
