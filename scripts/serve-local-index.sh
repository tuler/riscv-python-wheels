#!/bin/bash

# Set the parameters from the command line arguments
if [ $# -eq 2 ]; then
    pip_index_folder="$1"
    pip_index_port="$2"
else
    echo "Usage: $0 <pip-index-folder> <pip-index-port>"
    exit 1
fi

#verify that the pip-index folder exists
if [ ! -d "$pip_index_folder" ]; then
    echo "The pip-index folder does not exist: $pip_index_folder"
    exit 1
fi

echo "Serving pip index from ${pip_index_folder} on port ${pip_index_port}"

cd ${pip_index_folder}
python -m http.server ${pip_index_port}
