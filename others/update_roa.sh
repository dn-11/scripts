#!/bin/sh
FILE_URL="https://metadata.dn11.baimeow.cn/dn11_roa_bird2.conf"
DEST_DIR="/etc/bird"
DEST_FILE="${DEST_DIR}/dn11_roa_bird2.conf"
curl -sS -o "${DEST_FILE}" "${FILE_URL}" || {
    echo "Failed to download dn11_roa_bird2"
    exit 1
}
echo "File downloaded and saved to ${DEST_FILE}"
