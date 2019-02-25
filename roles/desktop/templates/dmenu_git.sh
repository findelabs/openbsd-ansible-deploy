#!/usr/local/bin/bash

declare -A gitdic
dirlist=()
while IFS= read -d $'\0' -r file ; do
   dir=$(basename "$(dirname "$file")")
   gitdic["$dir"]="$(dirname "$file")"
   dirlist+="$dir\n"
 done < <(find ~ -type d -name .git -print0)

choice=$(echo -e "$dirlist" | dmenu )
xfce4-terminal --working-directory="${gitdic["$choice"]}"
