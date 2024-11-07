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
				new_width=height
				new_height=width
				width=new_width
				height=new_height
			fi
			
			if [ "$width" -gt "$height" ]; then
				width=1920
				height=1080
			else
				width=1080
				height=1920
			fi

			# av1
			ffmpeg -i "$file" -vf scale="$width:$height" -c:v libsvtav1 -preset 4 -crf 23 -pix_fmt yuv420p10le -svtav1-params tune=0:film-grain=8 -c:a copy "${filename}_av1.mp4"
			# vp9
			ffmpeg -i "$file" -vf scale="$width:$height" -c:v libvpx-vp9 -crf 31 -b:v 1800k -minrate 900k -maxrate 2610k -tile-columns 2 -g 240 -threads 8 -quality good -pass 1 -speed 4 -an -f null /dev/null
			ffmpeg -i "$file" -vf scale="$width:$height" -c:v libvpx-vp9 -crf 31 -b:v 1800k -minrate 900k -maxrate 2610k -tile-columns 3 -g 240 -threads 8 -quality good -c:a libopus -pass 2 -speed 4 -y "${filename}_vp9.webm"
			# h264
			ffmpeg -i "$file" -vf scale="$width:$height" -c:v libx264 -preset 4 -crf 17 -pix_fmt yuv420p10le -x264opts qp=0 -movflags +faststart -c:a copy "${filename}_h264.mp4"
		done
	done
}

main $@

