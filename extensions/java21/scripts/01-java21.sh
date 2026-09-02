#!/usr/bin/env bash
set -euo pipefail

JAVA_VERSION=21
export JAVA_VERSION

if command -v apk >/dev/null 2>&1; then
  # *** Alpine ***
  jdk_os="alpine-linux"
elif command -v dpkg >/dev/null 2>&1; then
  # *** Debian/Ubuntu ***
  jdk_os="linux"
elif command -v rpm >/dev/null 2>&1; then
  # *** RedHat/Fedora ***
  jdk_os="linux"
elif command -v pacman >/dev/null 2>&1; then
  # *** Arch ***
  jdk_os="linux"
else
  echo "Unsupported distro" >&2
  exit 1
fi

case "$(uname -m)" in
  x86_64) jdk_arch="x64" ;;
  aarch64 | arm64) jdk_arch="aarch64" ;;
  *)
    echo "Unsupported host architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT
archive_path="${tmp_dir}/jdk.tar.gz"
jdk_home="${tmp_dir}/java"

curl -fsSL \
  "https://api.adoptium.net/v3/binary/latest/${JAVA_VERSION}/ga/${jdk_os}/${jdk_arch}/jdk/hotspot/normal/eclipse" \
  -o "${archive_path}"
mkdir -p "${jdk_home}"
tar -xzf "${archive_path}" --strip-components=1 -C "${jdk_home}"

if ! "${jdk_home}/bin/java" -version 2>&1 | grep -Eq "version \"${JAVA_VERSION}([.]|\")"; then
  echo "The downloaded JDK is not Java ${JAVA_VERSION}." >&2
  exit 1
fi

install_root="/opt/java"
versioned_home="${install_root}/java${JAVA_VERSION}"
mkdir -p "${install_root}"
rm -rf "${versioned_home}"
mv "${jdk_home}" "${versioned_home}"
ln -sfn "${versioned_home}" "${install_root}/latest"

for bin in "${install_root}/latest/bin/"*; do
  ln -sfn "${bin}" "/usr/local/bin/$(basename "${bin}")"
done

cat >/etc/profile.d/java.sh <<'JAVA'
export JAVA_HOME=/opt/java/latest
export PATH="$JAVA_HOME/bin:$PATH"
JAVA

# Debian/Ubuntu: register the unpacked JDK as one alternatives group. The
# slave links keep javac and the JDK tools on the same installation as java.
if command -v dpkg >/dev/null 2>&1; then
  java_home="/opt/java/latest"
  update-alternatives --install /usr/bin/java java "${java_home}/bin/java" "$((1700 + JAVA_VERSION))" \
    --slave /usr/bin/javac javac "${java_home}/bin/javac" \
    --slave /usr/bin/jar jar "${java_home}/bin/jar" \
    --slave /usr/bin/javadoc javadoc "${java_home}/bin/javadoc" \
    --slave /usr/bin/javap javap "${java_home}/bin/javap"
  update-alternatives --set java "${java_home}/bin/java"
fi

echo "java version output:"
java -version
echo "javac version output:"
javac -version
