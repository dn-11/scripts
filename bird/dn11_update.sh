#!/bin/sh

# Usage: cron job to run
# example: 0 2/12 * * * /etc/bird/dn11_update.sh

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
    local SAVE_NAME=$2
    local BASE_URL_1="https://metadata.dn11.ljcbaby.top"
    local BASE_URL_2="https://raw.githubusercontent.com/dn-11/metadata/main"
    local BASE_URL_3="https://metadata.dn11.baimeow.cn"
    
    if [ -z "${SAVE_NAME}" ]; then
        SAVE_NAME="${FILE_NAME}"
    fi

    if [ "$DOWNLOADER" = "wget" ]; then
        wget -q -O "${WORK_DIR}/${SAVE_NAME}" "${BASE_URL_1}/${FILE_NAME}" || \
        wget -q -O "${WORK_DIR}/${SAVE_NAME}" "${BASE_URL_2}/${FILE_NAME}" || \
        wget -q -O "${WORK_DIR}/${SAVE_NAME}" "${BASE_URL_3}/${FILE_NAME}" || {
            echo "Failed to download ${FILE_NAME}"
            exit 1
        }
    else
        curl -sS -o "${WORK_DIR}/${SAVE_NAME}" "${BASE_URL_1}/${FILE_NAME}" || \
        curl -sS -o "${WORK_DIR}/${SAVE_NAME}" "${BASE_URL_2}/${FILE_NAME}" || \
        curl -sS -o "${WORK_DIR}/${SAVE_NAME}" "${BASE_URL_3}/${FILE_NAME}" || {
            echo "Failed to download ${FILE_NAME}"
            exit 1
        }
    fi
    echo "File downloaded and saved to ${WORK_DIR}/${SAVE_NAME}"
}

function update_roa() {
    download_file "dn11_roa_bird2.conf"
    birdc configure
}

function check_update() {
    download_file "version" "version.new"
    VERSION_NEW=$(cat "${WORK_DIR}/version.new")

    if [ -f "${WORK_DIR}/version" ]; then
        VERSION_OLD=$(cat "${WORK_DIR}/version")

        if [ "$VERSION_NEW" != "$VERSION_OLD" ]; then
            mv "${WORK_DIR}/version" "${WORK_DIR}/version.old"
            return 1
        else
            rm -f "${WORK_DIR}/version.new"
            return 0
        fi
    else
        return 1
    fi
}

check_update

if [ $? -eq 1 ]; then
    echo "Updating..."

    update_roa
    
    mv "${WORK_DIR}/version.new" "${WORK_DIR}/version"
    rm -f "${WORK_DIR}/version.old"
    
    echo "Update completed."
else
    echo "No update needed."
fi
