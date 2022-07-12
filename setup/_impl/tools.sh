function add_if_not_present()
{
    FILE=$1
    LINE=$2
    grep -qxF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
}

function add_cronjob()
{
    SCRIPT=$1
    CRONJOB=$2
    (((crontab -l || true) | (grep -v "$SCRIPT" || true) ); echo "$CRONJOB") | crontab -
}
