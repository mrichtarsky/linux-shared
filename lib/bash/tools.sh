function add_if_not_present()
{
    FILE=$1
    LINE=$2
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
ls_1_time_sorted() {
    PATH=$1
    find "$PATH" -maxdepth 1 -not -path '*/.*' -printf "%T+ %p\n"  | sort -r | cut -d ' ' -f 2
}
