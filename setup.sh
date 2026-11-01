#!/bin/bash
# System Taiyaar (Ubuntu). Usage: ./setup.sh [all | <step> ...]

source "$(dirname "$0")/Bootup/lib.sh"

[ "$(uname -s)" = "Linux" ] || die "This is the Ubuntu branch. Use the macOS branch on a Mac."

# 'all' is for a fresh machine, so it leaves out clean and update.
ALL_STEPS="essentials rc ssh apps docker ros"

script_for() {
    case "$1" in
        essentials) echo essentials.sh ;;
        ssh)        echo ssh-keygen.sh ;;
        ros)        echo ROS.sh ;;
        clean)      echo clean.sh ;;
        apps)       echo install.sh ;;
        docker)     echo docker.sh ;;
        rc)         echo rc.sh ;;
        update)     echo update.sh ;;
        *)          return 1 ;;
    esac
}

usage() {
    cat <<USAGE
Usage: ./setup.sh [all | <step> ...]

  1) essentials   git, gh, glab and build tools, git identity
  2) ssh          SSH key, linked to GitHub/GitLab
  3) ros          ROS2 Humble (Ubuntu 22.04)
  4) clean        Conda and apt cleanup
  5) apps         Apps, Miniconda and Python packages
  6) docker       Docker Engine and Compose
  7) rc           Link the rc files into \$HOME
  8) update       Update apt, snap and Conda packages
  a) all          $ALL_STEPS
USAGE
}

if [ $# -eq 0 ]; then
    usage
    [ -t 0 ] || exit 1
    echo
    read -r -p "Pick steps (e.g. 1 2 5, or a): " choice
    for c in $choice; do
        case "$c" in
            1) set -- "$@" essentials ;;
            2) set -- "$@" ssh ;;
            3) set -- "$@" ros ;;
            4) set -- "$@" clean ;;
            5) set -- "$@" apps ;;
            6) set -- "$@" docker ;;
            7) set -- "$@" rc ;;
            8) set -- "$@" update ;;
            a|all) set -- "$@" all ;;
            *) die "Unknown choice: $c" ;;
        esac
    done
    [ $# -gt 0 ] || exit 0
fi

steps=""
for arg in "$@"; do
    case "$arg" in
        -h|--help) usage; exit 0 ;;
        all) steps="$steps $ALL_STEPS" ;;
        *)
            script_for "$arg" >/dev/null || { usage; die "Unknown step: $arg"; }
            steps="$steps $arg"
            ;;
    esac
done

# A failed step should not stop the rest of a fresh install.
failed=""
for step in $steps; do
    bash "$REPO_DIR/Bootup/$(script_for "$step")" || failed="$failed $step"
done

echo -e "\n$SEPARATOR"
if [ -n "$failed" ]; then
    warn "Finished with failures:$failed"
    exit 1
fi
ok "🎉 All done:$steps"
