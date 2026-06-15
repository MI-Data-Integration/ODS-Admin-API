#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

set -e
set +x

applicationName="EdFi.Ods.AdminApi"

# ENCRYPT_CONNECTION is handled by /opt/run-common.sh

# Source the shared common script (expected to be copied to /opt/run-common.sh by Dockerfile)
if [[ -f /opt/run-common.sh ]]; then
  # shellcheck source=Docker/shared/run-common.sh
  source /opt/run-common.sh
else
  echo "/opt/run-common.sh not found — please copy Docker/shared/run-common.sh to /opt/run-common.sh in your Dockerfile" >&2
  exit 1
fi


# read-only pipeline means read-only
#if [[ -f /ssl/server.crt ]]; then
#  cp /ssl/server.crt /usr/local/share/ca-certificates/
#  update-ca-certificates
#fi

# read-only pipeline means read-only
# Writing permissions for multitenant environment so the user can create tenants
#chmod 664 /app/appsettings.json

# Build and export connection strings, then wait for hosts
build_and_export_connection_strings
wait_for_hosts

echo "All configured database services are ready. Executing: $*"
exec dotnet "${applicationName}.dll"
