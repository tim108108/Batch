# Assign the result of `uname` to the variable `system_info`
system_info=$(uname)
current_path=$(pwd)

ftp_account="user"
ftp_password="user"

# Convert the parameter to lowercase and store it in a variable
target_ip=$(echo "$1" | tr '[:upper:]' '[:lower:]')
test_file=$2

# Windows script
windows_script() {

ip_name=$(echo $target_ip |cut -c1-1)
tmp_file=$(echo $test_file | rev | cut -c7- | rev)
log_file=_NIC_${ip_name}_${tmp_file}.log
start_time=$(date +"%Y/%m/%d %T.%3N")

mkdir NIC_${ip_name}_${tmp_file} -p
cp $test_file NIC_${ip_name}_${tmp_file}/${tmp_file}_O.txt

while true;do
current_time=$(date +"%Y/%m/%d %T.%3N")
echo "===================================================="
echo "=${start_time} -> ${current_time}="
echo "===================================================="

ftp -inv $target_ip<<EOF 
user $ftp_account $ftp_password
binary
quote PASV
put NIC_${ip_name}_${tmp_file}/${tmp_file}_O.txt ${tmp_file}_1.tmp
get ${tmp_file}_1.tmp NIC_${ip_name}_${tmp_file}/${tmp_file}_2.tmp
put NIC_${ip_name}_${tmp_file}/${tmp_file}_2.tmp ${tmp_file}_3.tmp
get ${tmp_file}_3.tmp NIC_${ip_name}_${tmp_file}/${tmp_file}_4.tmp
put NIC_${ip_name}_${tmp_file}/${tmp_file}_4.tmp ${tmp_file}_5.tmp
get ${tmp_file}_5.tmp NIC_${ip_name}_${tmp_file}/${tmp_file}_6.tmp
ls
bye
EOF

# compare file
if diff "NIC_${ip_name}_${tmp_file}/${tmp_file}_6.tmp" "NIC_${ip_name}_${tmp_file}/${tmp_file}_O.txt" > /dev/null; then
echo "File No Difference, Continuing..."    >> "NIC_${ip_name}_${tmp_file}/${log_file}"
echo "${current_time}"                      >> "NIC_${ip_name}_${tmp_file}/${log_file}"
echo "================================="    >> "NIC_${ip_name}_${tmp_file}/${log_file}"

rm NIC_${ip_name}_${tmp_file}/*.tmp
ftp -inv $target_ip <<EOF >>/dev/null
user $ftp_account $ftp_password
mdelete *.tmp
bye
EOF

else
echo "File Difference Detected!"            >> "NIC_${ip_name}_${tmp_file}/${log_file}"
echo "${current_time}"                      >> "NIC_${ip_name}_${tmp_file}/${log_file}"
echo "================================="    >> "NIC_${ip_name}_${tmp_file}/${log_file}"
break

fi

done
}

# Linux script
linux_script() {

ip_name=$(echo $target_ip |cut -c1-1)
tmp_file=$(echo $test_file | rev | cut -c7- | rev)
log_file=_NIC_${ip_name}_${tmp_file}.log
start_time=$(date +"%Y/%m/%d %T.%3N")

mkdir NIC_${ip_name}_${tmp_file} -p
cp $test_file NIC_${ip_name}_${tmp_file}/${tmp_file}_O.txt

while true;do
current_time=$(date +"%Y/%m/%d %T.%3N")
echo "===================================================="
echo "=${start_time} -> ${current_time}="
echo "===================================================="

ftp -in $target_ip<<EOF | awk '/^[d-]/ || /257/ {print $0}'
user $ftp_account $ftp_password
binary
put NIC_${ip_name}_${tmp_file}/${tmp_file}_O.txt ${tmp_file}_1.tmp
get ${tmp_file}_1.tmp NIC_${ip_name}_${tmp_file}/${tmp_file}_2.tmp
put NIC_${ip_name}_${tmp_file}/${tmp_file}_2.tmp ${tmp_file}_3.tmp
get ${tmp_file}_3.tmp NIC_${ip_name}_${tmp_file}/${tmp_file}_4.tmp
put NIC_${ip_name}_${tmp_file}/${tmp_file}_4.tmp ${tmp_file}_5.tmp
get ${tmp_file}_5.tmp NIC_${ip_name}_${tmp_file}/${tmp_file}_6.tmp
ls
bye
EOF

# compare file
if diff "NIC_${ip_name}_${tmp_file}/${tmp_file}_6.tmp" "NIC_${ip_name}_${tmp_file}/${tmp_file}_O.txt" > /dev/null; then
echo "File No Difference, Continuing..."    >> "NIC_${ip_name}_${tmp_file}/${log_file}"
echo "${current_time}"                      >> "NIC_${ip_name}_${tmp_file}/${log_file}"
echo "================================="    >> "NIC_${ip_name}_${tmp_file}/${log_file}"

rm NIC_${ip_name}_${tmp_file}/*.tmp
ftp -inv $target_ip <<EOF >>/dev/null
user $ftp_account $ftp_password
mdelete *.tmp
bye
EOF

else
echo "File Difference Detected!"            >> "NIC_${ip_name}_${tmp_file}/${log_file}"
echo "${current_time}"                      >> "NIC_${ip_name}_${tmp_file}/${log_file}"
echo "================================="    >> "NIC_${ip_name}_${tmp_file}/${log_file}"
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
            windows_script "$target_ip" "$test_file"
            ;;
        Linux)
            linux_script "$target_ip" "$test_file"
            ;;
        Darwin)
            echo "macOS system"
            ;;
        *)
            echo "unknown system"
            ;;
    esac
}

# Check if $target_ip contains only letters (a-zA-Z) and $test_file is not empty
if [ -n "$target_ip" ] && echo "$target_ip" | grep -q "^[a-zA-Z0-9.]*$" && [ -n "$test_file" ]; then
    # If $target_ip is not empty and contains only letters, proceed with the script
    script "$target_ip" "$test_file"
else
    # If $target_ip does not contain only letters, show usage information and exit
    echo "Usage: nic.sh [target ip] [test file]"
    exit 1
fi
