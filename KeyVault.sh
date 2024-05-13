#!/bin/bash

vaultName="KeyVault"
include_special_characters=false

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
    local fileS=$(find "$vaultName" -type f -name "$websiteName.txt")
    if [ -z "$fileS" ]; then
        echo "Password for '$websiteName' not found."
        exit 1
    fi
    echo "Password for '$websiteName':"
    cat "$fileS"
}

# Function to check if a file already exists
check_existence() {
    local fileSearch=$(find "$vaultName" -type f -name "$websiteName.txt")
    if [ ! -z "$fileSearch" ]; then
        echo "A file with name '$websiteName' already exists."
        exit 1
    fi
}

# Function to delete a password file
delete_password(){
    local fileSearch=$(find "$vaultName" -type f -name "$websiteName.txt")
    if [ ! -z "$fileSearch" ]; then
        echo "Are you sure you want to delete this file [$fileSearch]"
        read -p "Y/n: " response
        case "$response" in
            [yY])
                rm "$fileSearch"
                echo "Deleting file..."
                exit 0
                ;;
            [nN])
                echo "Canceled."
                ;;
            *)
                echo "Invalid input."
                ;;
        esac
        exit 1
    fi
}

# Function to list all stored passwords
list_passwords() {
    echo "Stored Passwords:"
    find "$vaultName" -type f -exec basename {} \;
    exit 0
}

# Function to update an existing password
update_password() {
    local fileSearch=$(find "$vaultName" -type f -name "$websiteName.txt")
    if [ -z "$fileSearch" ]; then
        echo "Password for '$websiteName' not found."
        exit 1
    fi
    pass=$(cat "$fileSearch")
    echo "old password : $pass"
    echo "Updating password for '$websiteName'"
    # Generate new password
    if [ "$include_special_characters" = true ]; then
        password="$(generate_password_special_characters)"
    else
        password="$(generate_password_no_special_characters)"
    fi
    # Store new password
    echo "$password" > "$fileSearch"
    echo "new password $password"
    echo "Password updated."
    exit 0
}

# Help menu
print_help() {
    echo "Usage: $0 [options] <website_name> "
    echo "Options:"
    echo "  -s         Show password for the given website name"
    echo "  -c         Include special characters in the generated password"
    echo "  -d         Delete password file from the vault"
    echo "  -l         List all stored passwords"
    echo "  -u         Update an existing password"
    echo "  -h         Display this help menu"
}

# Check if the vault directory exists, if not create it
if [ ! -d "$vaultName" ]; then
    mkdir -p "$vaultName"
fi
    
# Parse command-line options
while getopts "s:cd:lhu:" opt; do
    case $opt in
        s)
            websiteName="$OPTARG"
            show_password
            exit 0
            ;;
        c)
            include_special_characters=true
            ;;
        d)
            websiteName="$OPTARG"
            delete_password
            exit 0
            ;;
        l)
            list_passwords
            exit 0
            ;;
        u)
            websiteName="$OPTARG"
            update_password
            exit 0
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

shift $((OPTIND - 1))

if [ -z "$1" ]; then
    print_help
    exit 1
fi

websiteName="$1"
# Generate password
if [ "$include_special_characters" = true ]; then
    password="$(generate_password_special_characters)"
else
    password="$(generate_password_no_special_characters)"
fi

# Store password in a file
file="$vaultName/$websiteName.txt"

check_existence

touch "$file"
echo "$password" >> "$file"
chmod 600 "$file"

# Display the generated password
echo "Password for '$websiteName' generated and stored securely."
echo "Generated Password: $password"
