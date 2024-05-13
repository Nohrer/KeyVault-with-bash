# KeyVault-with-bash
This Bash script is a command-line tool for generating and managing passwords for various websites.
It provides functionality to create strong passwords with or without special characters, store them securely in a designated vault directory, and retrieve passwords for specific websites.

# Usage
./keyVault.sh <website_name> [options]

# Options
-s: Search for the password in the Vault.

-c: Include special characters in the generated password.

-h: Display the help menu.

# Notes
The vault directory (.KeyVault) is created in the current working directory if it doesn't already exist.
The script assumes that the user has the necessary permissions to create and modify files in the vault directory.
The script uses the sudo command to find and access files in the vault directory. This may require additional configuration or permissions depending on the system and user setup.
