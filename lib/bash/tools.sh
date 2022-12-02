function add_if_not_present()
{
    FILE=$1
    LINE=$2
    sed -i -e '$a\' "$FILE"  # Make sure newline at end
    grep -qxF "$LINE" "$FILE" || echo -e "$LINE" >> "$FILE"
}

function replace_or_add()
{
    FILE=$1
    TOKEN=$2
    LINE=$3
    sed -i "s/.*$TOKEN.*//" "$FILE"
    sed -i -e '$a\' "$FILE"  # Make sure newline at end
    grep -qxF "$LINE" "$FILE" || echo -e "$LINE" >> "$FILE"
}

function add_cronjob()
{
    SCRIPT=$1
    CRONJOB=$2
    (((crontab -l || true) | (grep -v "$SCRIPT" || true) ); echo "$CRONJOB") | crontab -
}


function rsync_common()
{
    rsync --compress --recursive --links --perms --executability --times --delete --delete-excluded --stats --info=progress2 --human-readable "$@"
}

# This is safer than just using 'ls -1t'
function ls_1_time_sorted() {
    find "$1" -maxdepth 1 -not -path '*/.*' -type f -printf "%T+ %p\n"  | sort -r | cut -d ' ' -f 2
}
