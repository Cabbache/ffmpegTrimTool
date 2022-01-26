#!/bin/bash

to_second(){
	H=$((3600 * $(echo -n "$1" | cut -d ':' -f1)))
	M=$((60 * $(echo -n "$1" | cut -d ':' -f2)))
	S=$(echo -n "$1" | cut -d ':' -f3)
	echo $((H+M+S))
}

if [[ $# -ne 2 ]]
then
	echo "Usage $0 inputvideo outputvideo"
	exit
fi

INC=1
while read line
do
	START=$(echo -n "$line" | cut -d',' -f1)
	END=$(echo -n "$line" | cut -d',' -f2)
	S_START=$(to_second "$START")
	S_END=$(to_second "$END")
	FFP="$FFP[0:v]trim=start=$S_START:end=$S_END,setpts=PTS-STARTPTS[v$INC];"
	FFP="$FFP[0:a]atrim=start=$S_START:end=$S_END,asetpts=PTS-STARTPTS[a$INC];"
	if [[ $INC -ne 1 ]]
	then
		FFP="$FFP[v$((INC-1))][v$INC]concat[v$((INC+1))];[a$((INC-1))][a$INC]concat=v=0:a=1[a$((INC+1))];"
		((INC++))
	fi
	((INC++))
done < cuts.txt
FFP=$(echo -n "$FFP" | head -c-1)
((INC--))

ffmpeg -i "$1" -filter_complex "$FFP" -map "[v$INC]" -map "[a$INC]" "$2"
