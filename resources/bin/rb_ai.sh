#!/bin/bash

# Script that execute the AI Llamafile to generate a title of given policies. 
# 
# Execution:
#     $ rb_ai.sh --options

# Verify the model exists
MODEL_PATH=/usr/lib/redborder/bin/llava-v1.5-7b-q4.llamafile

if [ ! -f "$MODEL_PATH" ]; then
  echo "Error: model not found at $MODEL_PATH"
  exit 1
fi

echo "......Model found......"

# Verify if there are params
if [ "$#" -eq 0 ]; then
  echo "Error: No arguments provided."
  echo -e "Usage: ./rb_ai.sh --options...\nExecutes the AI model.\nThe model used is Llamafile"
  exit 1
fi

/bin/bash "$MODEL_PATH" "$@"
