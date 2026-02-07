add_if_not_present() {
    FILE=$1
    LINE=$2
    tail -c1 "$FILE" | read -r _ || echo >> "$FILE";  # Make sure newline at end
    grep -qxF "$LINE" "$FILE" || echo -e "$LINE" >> "$FILE"
}

replace_or_add() {
    FILE=$1
    TOKEN=$2
    LINE=$3
    sed -i "/.*$TOKEN.*/d" "$FILE"
    tail -c1 "$FILE" | read -r _ || echo >> "$FILE";  # Make sure newline at end
    echo -e "$LINE" >> "$FILE"
}

add_cronjob() {
    SCRIPT=$1
    CRONJOB=$2
    { ( (crontab -l || true) | (grep -v "$SCRIPT" || true) ); echo "$CRONJOB"; } | crontab -
}

rsync_common() {
    # --executability: retains executability even if umask would remove it
    rsync --archive --executability --compress --delete --delete-excluded --stats --info=progress2 --human-readable --fake-super "$@"
}

rsync_common_delete() {
    rsync --archive --executability --compress --delete --delete-excluded --stats --info=progress2 --human-readable --fake-super "$@"
}

rsync_common_nodelete() {
    # --executability: retains executability even if umask would remove it
    rsync --archive --executability --compress --stats --info=progress2 --human-readable --fake-super "$@"
}

# This is safer than just using 'ls -1t'
files_toplevel_sorted_mtime() {
    find "$1" -maxdepth 1 -not -path '*/.*' -type f -printf "%T+ %p\n"  | sort -r | cut -d ' ' -f 2
}

files_and_dirs_toplevel_sorted_name() {
    find "$1" -maxdepth 1 -mindepth 1 -not -path '*/.*' |  sort -r
}

pushdq() {
    pushd "$@" >/dev/null || exit 1
}

popdq() {
    popd >/dev/null || exit 1
}

pushdt() {
    pushd "$@" >/dev/null || exit 1
    trap 'popd >/dev/null' EXIT
}

zfs_load_key() {
    POOL=$1
    KEYRING_SYSTEM=$2

    KEYSTATUS=$(zfs get -H -o value keystatus "$POOL" 2>/dev/null)

    if [ "$KEYSTATUS" != "available" ]; then
        /r/s/keyring_get "$KEYRING_SYSTEM" password | zfs load-key -L prompt "$POOL"
    fi
}

zfs_mount_pool() {
    POOL=$1
    KEYRING_SYSTEM=$2
    DATASET=${3:-$1}

    zpool import "$POOL" || true
    zfs_load_key "$POOL" "$KEYRING_SYSTEM"
    zfs mount "$DATASET" || true
}

git_checkout_latest_tag() {
    git checkout "$(git tag --sort=-v:refname | head -n 1)"
}
