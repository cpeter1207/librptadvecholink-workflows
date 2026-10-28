#!/usr/bin/env bash
# Fetch only released, signature-checked native Debian packages for the test image.
set -euo pipefail
destination=$1
version=$2
[[ "$version" =~ ^[0-9][0-9a-zA-Z.+:~_-]*$ ]]
mkdir -p "$destination"
destination=$(cd "$destination" && pwd)
temporary=$(mktemp -d)
trap 'rm -rf -- "$temporary"' EXIT
chmod 0755 "$temporary"
repository=https://cpeter1207.github.io/USBRadioPlus
curl --fail --location --silent --show-error --retry 3 --retry-all-errors \
  "$repository/usbradioplus-archive-keyring.gpg" --output "$temporary/key.gpg"
fingerprints=$(gpg --batch --quiet --show-keys --with-colons "$temporary/key.gpg" |
  awk -F: '$1 == "pub" { primary = 1; next }
    $1 == "fpr" && primary { print $10; primary = 0 }')
test "$fingerprints" = A0D5A79E0F5C45E9E63679950951502BAC795E55
printf 'deb [signed-by=%s] %s trixie main\n' \
  "$temporary/key.gpg" "$repository" > "$temporary/sources.list"
mkdir "$temporary/lists"
options=(-o "Dir::Etc::sourcelist=$temporary/sources.list"
  -o Dir::Etc::sourceparts=- -o "Dir::State::lists=$temporary/lists")
apt-get "${options[@]}" update
cd "$destination"
for package in librptadv-jitter-adapter1 librptadv-jitter-adapter-dev; do
  apt-get "${options[@]}" download "$package=$version"
  matches=("${package}"_*.deb)
  [[ ${#matches[@]} == 1 && -f "${matches[0]}" ]]
  [[ "$(dpkg-deb -f "${matches[0]}" Package)" == "$package" ]]
  [[ "$(dpkg-deb -f "${matches[0]}" Version)" == "$version" ]]
  [[ "$(dpkg-deb -f "${matches[0]}" Architecture)" == "$(dpkg --print-architecture)" ]]
done
