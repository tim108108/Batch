# Assign the result of `uname` to the variable `system_info`
system_info=$(uname)
current_path=$(pwd)

# Convert the parameter to lowercase and store it in a variable
param=$(echo "$1" | tr '[:upper:]' '[:lower:]')

# Windows script
windows_script() {
    echo "$current_path"
    cp $2 $param:
    echo "$2"
}

# Linux script
linux_script() {
    echo "$current_path"
    cp $2 /mnt/$param
    echo "$2"
}

# Script branch
script() {
    
    # Output system information
    echo "system: $system_info"
    
    # Perform actions based on the different systems
    case "$system_info" in
        Windows_NT)
            windows_script "$param" "$2"
            ;;
        Linux)
            linux_script "$param" "$2"
            ;;
        Darwin)
            echo "macOS system"
            ;;
        *)
            echo "unknown system"
            ;;
    esac
}

# Check if $param contains only letters (a-zA-Z) and $2 is not empty
if [ -n "$param" ] && echo "$param" | grep -q "^[a-zA-Z]*$" && [ -n "$2" ]; then
    # If $param is not empty and contains only letters, proceed with the script
    script "$param" "$2"
else
    # If $param does not contain only letters, show usage information and exit
    echo "Usage: dick.sh [file] [target disk]"
    exit 1
fi
