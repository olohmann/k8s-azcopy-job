#!/usr/bin/env bash

set -Eeuo pipefail

# script logic here
# AZCOPY_SOURCE_PATH - REQUIRED.
# AZCOPY_DESTINATION_PATH - REQUIRED.
# AZCOPY_DESTINATION_SAS - OPTIONAL. If not provided, this script will try to login 
#                          via a managed identity. If the VM or pod this is running in, 
#                          has a managed identity attached (in case of AKS, no PodIdentity needed, 
#                          just a user-assigned or system-assigned identity) and if that identity has 
#                          the needed permissions on the containers, then this will just work,
#                          without any token or credentials passed to the script.

# See https://docs.microsoft.com/en-us/azure/storage/common/storage-ref-azcopy-copy?toc=/azure/storage/blobs/toc.json
if [[ -z "${AZCOPY_DESTINATION_SAS:-}" ]]; then
  echo "Starting the copy operation using managed identity (in case there is one attached)."
  azcopy login --identity
  azcopy copy "${AZCOPY_SOURCE_PATH}" "${AZCOPY_DESTINATION_PATH}" --recursive --put-md5 --overwrite ifSourceNewer
else
  echo "Starting the copy operation using the provided SAS token."
  azcopy copy "${AZCOPY_SOURCE_PATH}" "${AZCOPY_DESTINATION_PATH}?${AZCOPY_DESTINATION_SAS}" --recursive --put-md5 --overwrite ifSourceNewer
fi