#!/usr/bin/env bash
# pass team - Password Store Extension (https://www.passwordstore.org/)
# Copyright (C) 2022 <nick@kousu.ca>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

set -euo pipefail

VERSION="0.0"

# a GPG key can be named by its fingerprint, which is a hex string
# (and used to be able to have spaces, or only be named by a prefix, but those wisely seems to have been removed)
# or by the fingerprint of one of its subkeys (which gpg just treats as a synonym)
# or by "user ID", which is a free form string
# (though which gpg --generate-key insists on writing as "{name} ({comment}) <{email@domain}>")
#
# I want to always canonicalize on the top-level fingerprints internally,
# but be able to display the user ID to help people out
_gpg_key_name() {
    C="$(gpg -k --with-colons --batch "${1}")" # gpg why
    echo $<<<"$C"
}

cmd_team_join() {
    local key_id="${1:-}"
    # TODO: use getopt like pass-otp does
    if [ -n '${key_id}' ]; then
        # user passed a GPG ID, try to look it up
        gpg --list-secret-keys "${key_id}" 2>/dev/null >/dev/null || die "GPG key ${key_id} unavailable."
    else
        # key not given, generate one default
        
        gpg --batch
    fi
}

cmd_team_usage() {
  cat <<-_EOF
Usage:
    $PROGRAM team init

        Import users to your GnuPG keyring.

    $PROGRAM team [list]

        Print team members.

    $PROGRAM team trust gpg-key


        $(tput bold)This reencrypts the entire database.$(tput sgr0) Be sure to run $(tput smul)pass git pull$(tput rmul) to avoid conflicts.

    $PROGRAM team revoke gpg-key


        $(tput bold)This reencrypts the entire database.$(tput sgr0) Be sure to run $(tput smul)pass git pull$(tput rmul) to avoid conflicts.

    $PROGRAM team add gpg-key


        gpg-key can be given by GPG ID

        e.g. $PROGRAM team add 8983325DA00B50E6F8915E5950F3300EE0F7E812
        e.g. $PROGRAM team add user@company.example.com
        e.g. $PROGRAM team add ./Downloads/user.asc # where user.asc is a file containing a GPG public key block

        $(tput bold)This reencrypts the entire database.$(tput sgr0) Be sure to run $(tput smul)pass git pull$(tput rmul) to avoid conflicts.

More information may be found in the pass-team(1) man page.
_EOF
  exit 0
}

cmd_team_version() {
  echo "$VERSION"
  exit 0
}

case "$1" in
  help|--help|-h) shift; cmd_team_usage "$@" ;;
  version|--version|-v) shift; cmd_team_version "$@" ;;
  *)                     cmd_team_usage "$@" ;;
esac
exit 0
