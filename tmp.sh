gop() {
    SEARCHPATH="${2-.}"
	RG_PREFIX="rg --files-with-matches -i"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1' '$SEARCHPATH'" \
			fzf --sort --preview="[[ ! -z {} ]] && rg -i --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q} $SEARCHPATH" \
				--preview-window="70%:wrap"
	)" &&
	e "$file"
}
