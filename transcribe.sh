#!/bin/bash

# requirements:
# whisper.cpp (https://github.com/ggerganov/whisper.cpp)
# whisper model
# a whisper tdrz model
# ffmpeg
# jq (brew install jq)

whisper_path="/Users/michal/Documents/Tools/whisper.cpp/main"
model_path="/Users/michal/Documents/Tools/whisper.cpp/models/ggml-small.en.bin"
api_key="YOUR_OPENAI_API_KEY"
gpt_model_id="gpt-3.5-turbo-1106"

transcripts_folder="/Users/michal/Movies/transcripts"
output_folder="/Users/michal/Documents/Notes/Temp"

cd $1;

if [ ! -d $1 ]; then
    echo "Directory not found: $1"
    exit 0
fi

if [ ! -d transcripts ]; then
    mkdir "$transcripts_folder"
fi
for file in *.mp4; do
    basename="${file%.mp4}"
    dir_name="$(dirname $file)"

    if [ ! -e "$transcripts_folder/$basename.txt" ]; then
        ffmpeg -i "$file" -ar 16000 "$basename".wav
        #echo "Converted $file to $wav_file"
        "$whisper_path" -of "$basename" -otxt -tdrz -m "$model_path" -f "$basename".wav
        
        system_prompt=$(cat gptprompt)
        transcription=$(cat "$basename.txt")
        content='{"model": "'"$gpt_model_id"'","messages": [{"role" : "system","content" : "'"$system_prompt"'"},{"role" : "user","content" : "'"$transcription"'"}]}'

        echo "$content" > tmp.json

        response=$(curl https://api.openai.com/v1/chat/completions \
        -H "Authorization: Bearer $api_key" \
        -H "Content-Type: application/json" \
        -d @tmp.json | jq -R '.' | jq -s '.' | jq -r 'join("")' | jq -r '.choices[0].message.content')

        echo "$response" > "$output_folder/$basename.md"

        rm "$basename".wav
        rm tmp.json

        mv "$basename.txt" "$transcripts_folder/$basename.txt"
    else
        echo "$basename.txt already exists for $file"
    fi
done

