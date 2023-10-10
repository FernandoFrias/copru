#set -x

function ejecutaNCMPCPP()
{
    echo "waiting for server $1 ..."
    ncmpcpp -c ~/.ncmpcpp/config$1
}

if [ "$#" = "1" ]; then
    if [[ "$1" = "1" || "$1" = "2" ]]; then
        to="$(pgrep ncmpcpp|wc -l)"
        if [[ "${to}" -gt 0 && "${to}" -le 2 ]]; then
            pidA=$(pgrep ncmpcpp|head -1)
            if [[ "${to}" -eq 2 ]]; then
                pidB=$(pgrep mpd|tail -1)
            fi
            inst=$(cat /proc/${pidA}/cmdline|sed -e 's/.\+mpd\([0-9]\).\+/\1\n/g')
            if [[ "$inst" =~ "$1" ]]; then
                echo "ncmpcpp $1 is running"
                exit 1
            fi
            if [ -n "${pidB}" ]; then
                inst=$(cat /proc/${pidB}/cmdline|sed -e 's/.\+mpd\([0-9]\).\+/\1\n/g')
                if [[ "$inst" =~ "$1" ]]; then
                    echo "ncmpcpp $1 is running"
                exit 1
                fi
            fi
            if [[ "$(mp.sh $1|sed -e "s/.\+ \([a-z]\+\)$/\1/g")" =~ (running|ejecutado) ]]; then
                ejecutaNCMPCPP $1
            fi
        else
            if [[ "${to}" -gt 2 ]]; then
                echo "there are ${to} ncmpcpp instances running"
                exit 1
            else
                if [[ "$(mp.sh $1|sed -e "s/.\+ \([a-z]\+\)$/\1/g")" =~ (running|ejecutado) ]]; then
                    ejecutaNCMPCPP $1
                fi
            fi
        fi
    else
        echo "np.sh (1|2)"
    fi
else
    echo "np.sh (1|2)"
fi
