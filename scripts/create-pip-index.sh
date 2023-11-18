#!/bin/bash

# Set the parameters from the command line arguments
if [ $# -eq 3 ]; then
    wheels_folder="$1"
    pip_index_folder="$2"
    whl_binary_base_url="$3"
else
    echo "Usage: $0 <wheels_folder> <pip_index_folder> <whl_binary_base_url>"
    exit 1
fi

# Verify that the wheels folder exists
if [ ! -d "$wheels_folder" ]; then
    echo "The wheels folder does not exist: $wheels_folder"
    exit 0
fi

# Verify that there are wheel files in the wheels folder
if [ ! "$(ls -A "$wheels_folder")" ]; then
    echo "No wheels to process, the wheels folder is empty: $wheels_folder"
    exit 0
fi

# Create the pip-index folder if it doesn't exist
mkdir -p "$pip_index_folder"

# Verify that the pip-index folder exists
if [ ! -d "$pip_index_folder" ]; then
    echo "Couldn't create the pip index folder: $pip_index_folder"
    exit 1
fi

# Create an index.html file for the wheels folder
general_index_file="$pip_index_folder/index.html"
echo "<!DOCTYPE html><html><head><title>Links for RISC-V Wheels</title></head><body><h1>Links for RISC-V Wheels</h1>" > "$general_index_file"

# Loop through all the wheel files
for wheel_file in $(ls "$wheels_folder"/*.whl | sort -f); do
    # Get the package name from the wheel file name
    package_name=$(basename "$wheel_file" | cut -d'-' -f1)
    
    #change _ and . to - in package name
    package_normalized_name=$(echo "$package_name" | sed 's/_/-/g')
    package_normalized_name=$(echo "$package_normalized_name" | sed 's/\./-/g')

    # force lowercase package name
    package_normalized_name=$(echo "$package_normalized_name" | tr '[:upper:]' '[:lower:]')
    
    # Add the package name to the index.html file only if it's not already there
    if ! grep -q "$package_normalized_name" "$general_index_file"; then
        echo "<div class='package' ><a href='$package_normalized_name/'>$package_normalized_name</a></div>" >> "$general_index_file"
    fi

    # Create a folder for the package in the pip-index folder
    package_folder="$pip_index_folder/$package_normalized_name"
    mkdir -p "$package_folder"

    # Create an index.html file for the package
    index_file="$package_folder/index.html"
    echo "<!DOCTYPE html><html><head><title>Links for $package_name</title></head><body><h1>Links for $package_name</h1>" > "$index_file"
    echo "<ul>" >> "$index_file"

    # Loop through all the wheels for the package
    for version_file in "$wheels_folder/$package_name"-*.whl; do
        # Get the version number from the wheel file name
        version=$(basename "$version_file")

        # Add the version to the index.html file
        link="<a href='$whl_binary_base_url/$version' data-requires-python='&gt;=3.10.0'>$version</a><br/>"
        echo "  <li>$link</li>" >> "$index_file"
    done
    echo "</ul></body></html>" >> "$index_file"
done
echo "</body></html>" >> "$general_index_file"