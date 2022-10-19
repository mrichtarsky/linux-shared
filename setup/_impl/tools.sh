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
