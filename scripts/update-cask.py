#!/usr/bin/env python3
"""Find a stable StatsDirect release and apply its verified version and checksum."""

import argparse
import json
import os
from pathlib import Path
import re
from urllib.request import Request, urlopen


REPOSITORY = "iain-buchan/statsdirect-mac"
CASK = Path(__file__).resolve().parents[1] / "Casks" / "statsdirect.rb"
VERSION = r"(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)"
SHA256 = r"[0-9a-f]{64}"


def version_parts(version):
    return tuple(map(int, version.split(".")))


def cask_fields(text):
    fields = []
    for name, pattern in (("version", VERSION), ("sha256", SHA256)):
        matches = list(re.finditer(rf'^  {name} "({pattern})"$', text, re.MULTILINE))
        if len(matches) != 1:
            raise ValueError(f"Expected exactly one {name} in the cask.")
        fields.append(matches[0])
    return fields


def latest_release():
    request = Request(
        f"https://api.github.com/repos/{REPOSITORY}/releases/latest",
        headers={"Accept": "application/vnd.github+json", "User-Agent": "StatsDirect-Homebrew-tap"},
    )
    with urlopen(request, timeout=30) as response:
        return json.load(response)


def stable_version(release):
    tag = release.get("tag_name", "")
    if release.get("draft") is not False or release.get("prerelease") is not False:
        raise ValueError("GitHub's latest release must be published and stable.")
    if not re.fullmatch(rf"v{VERSION}", tag):
        raise ValueError("The stable release needs a vMAJOR.MINOR.PATCH tag.")
    return tag[1:]


def signed_archive(release, version):
    name = f"StatsDirect-{version}-macOS-arm64.zip"
    url = f"https://github.com/{REPOSITORY}/releases/download/v{version}/{name}"
    matches = [asset for asset in release["assets"] if asset["name"] == name]
    if len(matches) != 1:
        raise ValueError(f"Expected one versioned release asset named {name}.")
    asset = matches[0]
    digest = re.fullmatch(rf"sha256:({SHA256})", asset.get("digest") or "")
    if asset.get("state") != "uploaded" or asset.get("browser_download_url") != url or not digest:
        raise ValueError(f"{name} needs its canonical URL and an uploaded SHA-256 digest.")
    return digest[1], url


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--apply", nargs=2, metavar=("VERSION", "SHA256"))
    args = parser.parse_args()

    text = CASK.read_text(encoding="utf-8")
    version_field, digest_field = cask_fields(text)
    current = version_field[1]
    release = latest_release()
    version = stable_version(release)
    if version_parts(version) < version_parts(current):
        print(f"The tap is already ahead of stable StatsDirect {version}.")
        return

    digest, url = signed_archive(release, version)
    update = version != current
    if not update and digest != digest_field[1]:
        raise ValueError(f"The published archive for {current} changed. Review it before updating the tap.")

    if args.apply:
        if args.apply != [version, digest]:
            raise ValueError("The stable release changed during verification. Run the workflow again.")
        if update:
            text = text.replace(version_field[0], f'  version "{version}"', 1)
            text = text.replace(digest_field[0], f'  sha256 "{digest}"', 1)
            CASK.write_text(text, encoding="utf-8")
            print(f"Updated the cask to StatsDirect {version}.")
        return

    output = os.getenv("GITHUB_OUTPUT")
    if output:
        with Path(output).open("a", encoding="utf-8") as stream:
            stream.write(f"version={version}\nsha256={digest}\nurl={url}\nupdate={str(update).lower()}\n")
    print(f"Stable StatsDirect {version} " + ("is ready for verification." if update else "matches the cask."))


if __name__ == "__main__":
    try:
        main()
    except (KeyError, OSError, TypeError, ValueError) as error:
        raise SystemExit(str(error)) from error
