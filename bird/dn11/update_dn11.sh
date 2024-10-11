#!/bin/sh

. ./config.sh
. ./functions.sh

function download_file() {
    local FILE_NAME=$1
    local SAVE_NAME=$2
    local BASE_URL_1="https://raw.githubusercontent.com/dn-11/metadata/main"
    local BASE_URL_2="https://metadata.dn11.baimeow.cn"
    
    if [ -z "${SAVE_NAME}" ]; then
        SAVE_NAME="${FILE_NAME}"
    fi

    curl -sS -o "${WORK_DIR}/${SAVE_NAME}" "${BASE_URL_1}/${FILE_NAME}" || {
        curl -sS -o "${WORK_DIR}/${SAVE_NAME}" "${BASE_URL_2}/${FILE_NAME}" || {
            echo "Failed to download ${FILE_NAME}"
            exit 1
        }
    }
    echo "File downloaded and saved to ${WORK_DIR}/${SAVE_NAME}"
}

function update_roa() {
    download_file "dn11_roa_bird2.conf"
    birdc configure
}

function update_static_rt() {
    download_file "dn11_ipcidr.txt"

    # # for less lines
    # sed -i '/^172.16/d' "${WORK_DIR}/dn11_ipcidr.txt" 

    for line in $(cat "${WORK_DIR}/dn11_ipcidr.txt"); do
        set_ik_srt "${line}"
    done

    clean_ik_srt
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

    if [ $ENABLE_ROA -eq 1 ]; then
        update_roa
    fi

    if [ $ENABLE_IK_SRT -eq 1 ]; then
        update_static_rt
    fi
    
    mv "${WORK_DIR}/version.new" "${WORK_DIR}/version"
    rm -f "${WORK_DIR}/version.old"
    
    echo "Update completed."
else
    echo "No update needed."
fi
