#!/usr/bin/env bash

# set -Eeuo pipefail
# trap cleanup SIGINT SIGTERM ERR EXIT

# cleanup() {
#   trap - SIGINT SIGTERM ERR EXIT
#   # script cleanup here
# }


# script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

# script logic here
# AZCOPY_SOURCE_PATH - REQUIRED.
# AZCOPY_DESTINATION_PATH - REQUIRED.
# AZCOPY_DESTINATION_SAS - OPTIONAL. If not provided, this script will try to login via a managed identity. If the VM or pod this is running in, has a managed identity attached (in case of AKS, no PodIdentity needed, just a user-assigned or system-assigned identity) and if that identity has the needed permissions on the containers, then this will just work, without any token or credentials passed to the script.

if [[ -z "${AZCOPY_DESTINATION_SAS}" ]]; then
  echo "Starting the copy operation using managed identity (in case we have one attached)."
  #TODO: Test the managed identity.
  azcopy login --identity
  azcopy sync "${AZCOPY_SOURCE_PATH}" "${AZCOPY_DESTINATION_PATH}" --recursive --put-md5
else
  echo "Starting the copy operation using the provided SAS token."
  azcopy sync "${AZCOPY_SOURCE_PATH}" "${AZCOPY_DESTINATION_PATH}?${AZCOPY_DESTINATION_SAS}" --recursive --put-md5
fi
