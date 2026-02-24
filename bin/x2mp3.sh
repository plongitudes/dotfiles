#!/usr/bin/env bash
for dir in *.$1; do
    name=$(echo $dir | cut -d . -f 1)
    ext_s="$1"
    ext_t="mp3"
    echo $name | tr -d '\n' | xargs -0 -I % ffmpeg -i "%.$ext_s" -acodec libmp3lame -qscale:a 0 "%.$ext_t"
done

