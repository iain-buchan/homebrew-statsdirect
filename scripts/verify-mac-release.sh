#!/bin/bash
set -euo pipefail

version="${1:?Expected a version}"
sha256="${2:?Expected a SHA-256 digest}"
url="${3:?Expected the versioned download URL}"
work="$(mktemp -d "${RUNNER_TEMP:-${TMPDIR:-/tmp}}/statsdirect-release.XXXXXX")"
archive="$work/StatsDirect.zip"

curl --fail --silent --show-error --location --retry 3 \
  --proto '=https' --proto-redir '=https' "$url" --output "$archive"
printf '%s  %s\n' "$sha256" "$archive" | shasum -a 256 -c
ditto -x -k "$archive" "$work"

app="$work/StatsDirect.app"
plist="$app/Contents/Info.plist"
test "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$plist")" = "$version"
test "$(/usr/libexec/PlistBuddy -c 'Print :LSMinimumSystemVersion' "$plist")" = "14.0"
test "$(lipo -archs "$app/Contents/MacOS/StatsDirect")" = "arm64"

requirement='identifier "com.statsdirect.viewer.prototype" and anchor apple generic and certificate 1[field.1.2.840.113635.100.6.2.6] exists and certificate leaf[field.1.2.840.113635.100.6.1.13] exists and certificate leaf[subject.OU] = "675296U8XP"'
codesign --verify --deep --strict "$app"
codesign --verify --strict -R="$requirement" "$app"
xcrun stapler validate "$app"
syspolicy_check distribution "$app"
