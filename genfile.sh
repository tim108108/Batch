
# Convert the parameter to uppercase and store it in a variable
param=$(echo "$1" | tr '[:lower:]' '[:upper:]')

# Determine the parameter and choose to generate a 1MB or 10MB file
case "$param" in
    1MB)
        size=1048576  # 1MB = 1024 * 1024 bytes
        ;;
    2MB)
        size=2097152  # 2MB = 2 * 1024 * 1024 bytes
        ;;
    5MB)
        size=5242880  # 5MB = 5 * 1024 * 1024 bytes
        ;;
    10MB)
        size=10485760 # 10MB = 10 * 1024 * 1024 bytes
        ;;
    *)
        echo "Usage: $0 1MB|2MB|5MB|10MB"
        exit 1
        ;;
esac

# Generate a sequence of numbers and write them to temp.txt
seq 0 127 | tr '\n' ' ' > temp.txt

# Use cat and repeated appending to approach the desired file size
while [ $(stat -c%s temp.txt) -lt $size ]; do
    cat temp.txt >> temp2.txt
    cat temp2.txt >> temp.txt
done

# Use head to extract the specified number of bytes for the output file
head -c $size temp.txt > $param"_G".txt

# Remove temporary files
rm temp.txt temp2.txt

echo "$param"_G".txt has been successfully created with a size of $param."
