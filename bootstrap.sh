#!/bin/bash
# Detects the OS, clones only its branch, and starts setup.
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/ItsShriks/SystemTaiyaar/macOS/bootstrap.sh)"
# Any arguments are passed to setup.sh. Run through bash -c, not a pipe, so its prompts can read the keyboard.
set -euo pipefail

REPO_URL="${SYSTEM_TAIYAAR_REPO:-https://github.com/ItsShriks/SystemTaiyaar.git}"
TARGET="${SYSTEM_TAIYAAR_DIR:-$HOME/SystemTaiyaar}"

die() { echo "Error: $1" >&2; exit 1; }

case "$(uname -s)" in
    Darwin)
        BRANCH="macOS"
        ;;
    Linux)
        [ -r /etc/os-release ] || die "Cannot read /etc/os-release to identify this Linux."
        os_ids="$(. /etc/os-release && echo "${ID:-} ${ID_LIKE:-}")"
        case " $os_ids " in
            *" ubuntu "*) BRANCH="Ubuntu" ;;
            *) die "Only macOS and Ubuntu are supported, this is: $os_ids" ;;
        esac
        ;;
    *)
        die "Only macOS and Ubuntu are supported, this is: $(uname -s)"
        ;;
esac
echo "Detected $BRANCH"

if [ "$BRANCH" = "macOS" ]; then
    # On a fresh Mac, git is only a stub until the Command Line Tools are installed
    if ! xcode-select -p >/dev/null 2>&1; then
        echo "Installing the Xcode Command Line Tools. Accept the dialog, this script waits for it."
        xcode-select --install || true
        until xcode-select -p >/dev/null 2>&1; do sleep 10; done
    fi
elif ! command -v git >/dev/null; then
    sudo apt-get update
    sudo apt-get install -y git
fi

if [ -d "$TARGET/.git" ]; then
    current="$(git -C "$TARGET" branch --show-current)"
    [ "$current" = "$BRANCH" ] || die "$TARGET is on branch '$current', expected '$BRANCH'. Move it or set SYSTEM_TAIYAAR_DIR."
    git -C "$TARGET" pull --ff-only
elif [ -e "$TARGET" ]; then
    die "$TARGET already exists and is not a git clone. Move it or set SYSTEM_TAIYAAR_DIR."
else
    git clone --single-branch --branch "$BRANCH" "$REPO_URL" "$TARGET"
fi

exec "$TARGET/setup.sh" "$@"
