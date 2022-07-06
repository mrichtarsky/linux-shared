function add_if_not_present()
{
    FILE=$1
    LINE=$2
    grep -qxF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
}
