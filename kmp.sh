#personal parse
comp $1 2>/dev/null|dos2unix|grep -v -e ^$|dos2unix|grep -v 'Previous\|\$\|Total generated'|gawk -f /home/fafrias/.local/share/awk/parse1.awk
