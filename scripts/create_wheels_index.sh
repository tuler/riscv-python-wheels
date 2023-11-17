#!/bin/bash

# Set the paths for the wheels and pip-index folders
wheels_folder="./wheels"
pip_index_folder="./pip-index"

# Create the pip-index folder if it doesn't exist
mkdir -p "$pip_index_folder"

# Create an index.html file for the wheels folder
general_index_file="$pip_index_folder/index.html"
echo "<!DOCTYPE html><html><head><title>Links for RISC-V Wheels</title></head><body><h1>Links for RISC-V Wheels</h1>" > "$general_index_file"

# Loop through all the wheel files
for wheel_file in $(ls "$wheels_folder"/*.whl | sort); do
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
        link="<a href='https://raw.githubusercontent.com/lucas-marc/riscv-wheels/main/wheels/$version' data-requires-python='&gt;=3.10.0'>$version</a><br/>"
        echo "  <li>$link</li>" >> "$index_file"
    done
    echo "</ul></body></html>" >> "$index_file"
done