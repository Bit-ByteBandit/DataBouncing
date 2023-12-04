#!/bin/bash

file="./raw.txt"

tail -f "$file" | while read line; do
    # Process each line here
    echo "$line"

    # Your custom logic or conditions can go here
    # If you need to break out of the loop, you can use 'break'
done
