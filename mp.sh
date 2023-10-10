#set -x

function ejecutaMPD
{
    mpd ~/.config/mpd$1/mpd.conf
    echo "mpd $1 ejecutado"
}

if [ "$#" = "1" ]; then
    if [[ "$1" = "1" || "$1" = "2" ]]; then
        to="$(pgrep mpd|wc -l)"
        if [[ "${to}" -gt 0 && "${to}" -le 2 ]]; then
            pidA=$(pgrep mpd|head -1)
            if [[ "${to}" -eq 2 ]]; then
                pidB=$(pgrep mpd|tail -1)
            fi
            inst=$(cat /proc/${pidA}/cmdline|sed -e 's/.\+mpd\([0-9]\).\+/\1\n/g')
            if [[ "$inst" =~ "$1"  ]]; then
                echo "mp $1 is running"
                exit 1
            fi
            if [ -n "${pidB}" ]; then
                inst=$(cat /proc/${pidB}/cmdline|sed -e 's/.\+mpd\([0-9]\).\+/\1\n/g')
                if [[ "$inst" =~ "$1"  ]]; then
                    echo "mp $1 is running"
                    exit 1
                fi
            fi
             ejecutaMPD $1
        else
            if [[ "${to}" -gt 2 ]]; then
                echo "there are ${to} mpd instances running"
                exit 1
            else
                 ejecutaMPD $1
            fi
        fi
    else
        echo "mp.sh (1|2)"
    fi

else
    echo "mp.sh (1|2)"
fi
