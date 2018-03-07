#!/bin/sh
set -e

git_clone_or_update() {
  giturl=$1
  gitrepo=${giturl##*/}   # foo.git
  gitrepo=${gitrepo%.git} # foo
  if [ ! -d "$gitrepo" ]; then
    git clone "$giturl"
  else
    (cd "$gitrepo" && git pull >/dev/null)
  fi
}
date_iso8601() {
  date -u +%Y-%m-%dT%H:%M:%SZ
}

git_clone_or_update https://github.com/client9/shlib.git
cd shlib

now=$(date_iso8601)
echo "// Code generated ${now} DO NOT EDIT."
echo "package main"
echo ""
echo 'const shellfn = `'
cat \
  license.sh \
  is_command.sh \
  uname_os.sh \
  uname_arch.sh \
  uname_os_check.sh \
  uname_arch_check.sh \
  untar.sh \
  mktmpdir.sh \
  http_download.sh \
  github_api.sh \
  github_last_release.sh \
  hash_sha256.sh \
  license_end.sh \
  | grep -v '^#' | grep -v ' #' | tr -s '\n'

echo '`'
