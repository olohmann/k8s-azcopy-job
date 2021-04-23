#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}


script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

# script logic here
# AZCOPY_SOURCE_PATH - REQUIRED.
# AZCOPY_DESTINATION_PATH - REQUIRED.
# AZCOPY_DESTINATION_SAS - REQUIRED.
azcopy sync "${AZCOPY_SOURCE_PATH}" "${AZCOPY_DESTINATION_PATH}?${AZCOPY_DESTINATION_SAS}" --recursive --put-md5

