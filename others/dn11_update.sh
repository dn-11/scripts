#!/bin/sh

# Usage: cron job to run
# example: 0 X * * * /etc/bird/dn11_update.sh
# X can be any hour, recommend to 1~6

# sleep for no burst
sleep $((RANDOM % 60))

WORK_DIR="/etc/bird"

# Check for wget or curl
if command -v wget >/dev/null 2>&1; then
    DOWNLOADER="wget"
elif command -v curl >/dev/null 2>&1; then
    DOWNLOADER="curl"
else
    echo "Neither wget nor curl is installed. Please install one of them."
    exit 1
fi

function download_file() {
    local FILE_NAME=$1
    local SAVE_PATH=$2
    local BASE_URL_1="https://metadata.dn11.ljcbaby.top" # Tencent Cloud EdgeOne
    local BASE_URL_2="https://raw.githubusercontent.com/dn-11/metadata/main" # GitHub
    local BASE_URL_3="https://metadata.dn11.baimeow.cn" # Tencent Cloud COS
    
    if [ -z "${SAVE_PATH}" ]; then
        SAVE_PATH="${WORK_DIR}/${FILE_NAME}"
    fi

    if [ "$DOWNLOADER" = "wget" ]; then
        wget -q -O "${SAVE_PATH}" "${BASE_URL_1}/${FILE_NAME}" || \
        wget -q -O "${SAVE_PATH}" "${BASE_URL_2}/${FILE_NAME}" || \
        wget -q -O "${SAVE_PATH}" "${BASE_URL_3}/${FILE_NAME}" || {
            echo "Failed to download ${FILE_NAME}"
            exit 1
        }
    else
        curl -sS -o "${SAVE_PATH}" "${BASE_URL_1}/${FILE_NAME}" || \
        curl -sS -o "${SAVE_PATH}" "${BASE_URL_2}/${FILE_NAME}" || \
        curl -sS -o "${SAVE_PATH}" "${BASE_URL_3}/${FILE_NAME}" || {
            echo "Failed to download ${FILE_NAME}"
            exit 1
        }
    fi
    echo "File downloaded and saved to ${SAVE_PATH}"
}

function reload_bird() {
    FLAG=0
    NOW=$(date +%s)

    if [ -f "/etc/bird.conf" ]; then
        MTIME=$(date +%s -r "/etc/bird.conf")
        DIFF=$((NOW - MTIME))
        if [ "$DIFF" -le 600 ]; then
            FLAG=1
        fi
    fi

    # check if any .conf file in WORK_DIR modified in last 10 minutes
    for conf_file in "$WORK_DIR"/*.conf; do
        if [ -f "$conf_file" ]; then
            # skip roa file 
            if [ "$conf_file" = "${WORK_DIR}/dn11_roa_bird2.conf" ]; then
                continue
            fi
            MTIME=$(date +%s -r "$conf_file")
            DIFF=$((NOW - MTIME))
            if [ "$DIFF" -le 600 ]; then
                FLAG=1
                break
            fi
        fi
    done

    if [ "$FLAG" -eq 1 ]; then
        echo "Configuration changed recently, skip bird reload."
        return
    fi

    birdc configure soft
}

function check_update() {
    download_file "version" "/tmp/dn11_version_now"
    VERSION_NEW=$(cat "/tmp/dn11_version_now")

    ROA_FILE="${WORK_DIR}/dn11_roa_bird2.conf"
    if [ -f "$ROA_FILE" ]; then
        MTIME=$(date +%s -r "$ROA_FILE")
        if [ "$VERSION_NEW" -gt "$MTIME" ]; then
            return 1
        else
            return 0
        fi
    else
        return 1
    fi
}

check_update

if [ $? -eq 1 ]; then
    echo "Updating..."

    download_file "dn11_roa_bird2.conf"

    reload_bird

    echo "Update completed."
else
    echo "No update needed."
fi

rm /tmp/dn11_version_now
