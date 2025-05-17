#!/usr/bin/env sh

verify_commands() {
	commands=("ffmpeg" "ffprobe")
	for command in "${commands[@]}"; do
		which $command &> /dev/null
		if [ $? -ne 0 ]; then
			echo "command '$command' not found"
			exit 1
		fi
	done
}

main() {
	verify_commands

	for arg in "$@"; do
		for file in $(ls "$arg"); do
			filename="${file%.*}"
			extension="${file##*.}"
			if [ "$extension" != "mp4" ]; then
				echo "Invalid filetype: $file (expected mp4)"
				continue
			fi

			width=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=noprint_wrappers=1:nokey=1 "$file")
			height=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=noprint_wrappers=1:nokey=1 "$file")
			rotation=$(ffprobe -v error -select_streams v:0 -show_entries stream_side_data=rotation -of default=noprint_wrappers=1:nokey=1 "$file")
			if [ "$rotation" -eq "90" ] || [ "$rotation" -eq "-90" ]; then
				new_width=$height
				new_height=$width
				width=$new_width
				height=$new_height
			fi

			if [ "$width" -gt "$height" ]; then
				width=1920
				height=-1
			else
				width=-1
				height=1920
			fi
			ffmpeg -i "$file" -vf scale="$width:$height" -c:v libsvtav1 -preset 4 -crf 23 -pix_fmt yuv420p10le -svtav1-params tune=0:film-grain=8 -c:a copy "${filename}_compressed.${extension}"
		done
	done
}

main $@
