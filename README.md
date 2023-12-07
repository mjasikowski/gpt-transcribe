# gpt-transcribe
A bash script to transcribe .mp4 recordings and summarize the transcripts in the Markdown format

It transcribes all the mp4 files in the specified folder as long as they don't already have a corresponding txt file in the transcriptions directory already.

Usage:
1. Install requirements:
   - whisper.cpp
   - a whisper model
   - a whisper tdrz model
   - ffpmeg (available in homebrew)
   - jq (available in homebrow)
2. Get your OpenAI API key
3. Configure the variables inside transcribe.sh
   - whisper_path: path to the `main` executable inside whisper.cpp
   - model_path: path to your whisper.cpp model
   - api_key: your OpenAI API key
   - gpt_model_id: the ID of the OpenAI model that you wish to use
   - transcripts_folder: the directory in which the raw transcripts will be stored
   - output_folder: the directory in which the .md file will be stored
4. Tune the system prompt in `gptprompt` as you see fit
5. Run the script: `bash transcribe.sh .`

Pro tip: You can record your calls to mp4 with OBS.

This script was produced for personal during a sleepless evening, so it may contain errors.
Make sure that you only use it for things that you're not afraid to send to OpenAI servers.
