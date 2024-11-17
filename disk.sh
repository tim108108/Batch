# Assign the result of `uname` to the variable `system_info`
system_info=$(uname)
current_path=$(pwd)
current_time=$(date +"%Y/%m/%d %T")


# Convert the parameter to lowercase and store it in a variable
target_path=$(echo "$1" | tr '[:upper:]' '[:lower:]')
test_file=$2

# Windows script
windows_script() {
    tmp_file=$(echo "$target_path" | tr '[:lower:]' '[:upper:]')_${test_file:0:-6}
    log_file="_Disk_${tmp_file}.log"
    mkdir "Disk_${tmp_file}" -p
    cp $test_file "Disk_${tmp_file}/${tmp_file}_O.txt"
    while true;do
        echo -e "=====================\n=${current_time}=\n====================="
        cp Disk_${tmp_file}/${tmp_file}_O.txt ${target_path}:/${tmp_file}_1.tmp
        cp ${target_path}:/${tmp_file}_1.tmp Disk_${tmp_file}/${tmp_file}_2.tmp
        cp Disk_${tmp_file}/${tmp_file}_2.tmp ${target_path}:/${tmp_file}_3.tmp
        cp ${target_path}:/${tmp_file}_3.tmp Disk_${tmp_file}/${tmp_file}_4.tmp
        cp Disk_${tmp_file}/${tmp_file}_4.tmp ${target_path}:/${tmp_file}_5.tmp
        cp ${target_path}:/${tmp_file}_5.tmp Disk_${tmp_file}/${tmp_file}_6.tmp
        
        # compare file
        if diff "Disk_${tmp_file}/${tmp_file}_6.tmp" "Disk_${tmp_file}/${tmp_file}_O.txt" > /dev/null; then
            echo "File No Difference, Continuing...">> "Disk_${tmp_file}/${log_file}"
            echo "$(date +"%Y/%m/%d %T")" >> "Disk_${tmp_file}/${log_file}"
            echo "=================================" >> "Disk_${tmp_file}/${log_file}"
            rm Disk_${tmp_file}/*.tmp
            rm ${target_path}:/*.tmp
        else
            echo "File Difference Detected!" >> "Disk_${tmp_file}/${log_file}"
            echo "$(date +"%Y/%m/%d %T")" >> "Disk_${tmp_file}/${log_file}"
            echo "=================================" >> "Disk_${tmp_file}/${log_file}"
            break
        fi
    done

}

# Linux script
linux_script() {
    target_path="/mnt/$(echo "$target_path" | tr '[:upper:]' '[:lower:]')"
    tmp_file=$(echo "$test_file" | rev | cut -c7- | rev)
    log_file="_Disk_${tmp_file}.log"
    mkdir "Disk_${tmp_file}" -p
    cp $test_file "Disk_${tmp_file}/${tmp_file}_O.txt"
    cp Disk_${tmp_file}/${tmp_file}_O.txt ${target_path}/${tmp_file}_1.tmp
    while true;do
        echo "=====================\n=${current_time}=\n====================="
        cp Disk_${tmp_file}/${tmp_file}_O.txt ${target_path}/${tmp_file}_1.tmp
        cp ${target_path}/${tmp_file}_1.tmp Disk_${tmp_file}/${tmp_file}_2.tmp
        cp Disk_${tmp_file}/${tmp_file}_2.tmp ${target_path}/${tmp_file}_3.tmp
        cp ${target_path}/${tmp_file}_3.tmp Disk_${tmp_file}/${tmp_file}_4.tmp
        cp Disk_${tmp_file}/${tmp_file}_4.tmp ${target_path}/${tmp_file}_5.tmp
        cp ${target_path}/${tmp_file}_5.tmp Disk_${tmp_file}/${tmp_file}_6.tmp
        
        # compare file
        if diff "Disk_${tmp_file}/${tmp_file}_6.tmp" "Disk_${tmp_file}/${tmp_file}_O.txt" > /dev/null; then
            echo "File No Difference, Continuing...">> "Disk_${tmp_file}/${log_file}"
            echo "$(date +"%Y/%m/%d %T")" >> "Disk_${tmp_file}/${log_file}"
            echo "=================================" >> "Disk_${tmp_file}/${log_file}"
            rm Disk_${tmp_file}/*.tmp
            rm ${target_path}/*.tmp
        else
            echo "File Difference Detected!" >> "Disk_${tmp_file}/${log_file}"
            echo "$(date +"%Y/%m/%d %T")" >> "Disk_${tmp_file}/${log_file}"
            echo "=================================" >> "Disk_${tmp_file}/${log_file}"
            break
        fi
    done
}

# Script branch
script() {
    
    # Output system information
    echo "system: $system_info"
    
    # Perform actions based on the different systems
    case "$system_info" in
        Windows_NT)
            windows_script "$target_path" "$test_file"
            ;;
        Linux)
            linux_script "$target_path" "$test_file"
            ;;
        Darwin)
            echo "macOS system"
            ;;
        *)
            echo "unknown system"
            ;;
    esac
}

# Check if $target_path contains only letters (a-zA-Z) and $test_file is not empty
if [ -n "$target_path" ] && echo "$target_path" | grep -q "^[a-zA-Z]*$" && [ -n "$test_file" ]; then
    # If $target_path is not empty and contains only letters, proceed with the script
    script "$target_path" "$test_file"
else
    # If $target_path does not contain only letters, show usage information and exit
    echo "Usage: dick.sh [target disk] [test file]"
    exit 1
fi
