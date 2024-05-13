#!/bin/bash

# Function to generate a strong password with special characters
generate_password_special_characters() {
    cat /dev/urandom | tr -dc '[:graph:]' | fold -w 15 | head -n 1
}

# Function to generate a strong password without special characters
generate_password_no_special_characters() {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1
}

# Function to show password for a given website name
show_password() {
    local fileS=$(sudo find "$vaultName" -type f -name "$websiteName.txt")
    if [ -z "$fileS" ]; then
        echo "Password for '$websiteName' not found."
        exit 1
    fi
    echo "Password for '$websiteName':"
    cat "$fileS"
}

# Function to check if a file already exists
check_existence() {
    local fileSearch=$(sudo find "$vaultName" -type f -name "$websiteName*")
    if [ ! -z "$fileSearch" ]; then
        echo "A file with name '$websiteName' already exists."
        exit 1
    fi
}

# Help menu
print_help() {
    echo "Usage: $0 <website_name> [options]"
    echo "Options:"
    echo "  -s         Show password for the given website name"
    echo "  -c         Include special characters in the generated password"
    echo "  -h         Display this help menu"
}

# Check if a website name is provided
if [ -z "$1" ]; then
    print_help
    exit 1
fi

# Set default values
vaultName=".KeyVault"
websiteName="$1"
include_special_characters=false

# Parse command-line options
while getopts "sch" opt; do
    case $opt in
        s)
            show_password
            exit 0
            ;;
        c)
            include_special_characters=true
            ;;
        h)
            print_help
            exit 0
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            print_help
            exit 1
            ;;
    esac
done

# Check if file already exists
check_existence

# Generate password
if [ "$include_special_characters" = true ]; then
    password="$(generate_password_special_characters)"
else
    password="$(generate_password_no_special_characters)"
fi

# Store password in a file
file="$vaultName/$websiteName.txt"
touch "$file"
echo "$password" >> "$file"
chmod 600 "$file"

# Display the generated password
echo "Password for '$websiteName' generated and stored securely."
echo "Generated Password: $password"
