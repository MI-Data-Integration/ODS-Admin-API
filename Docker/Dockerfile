# syntax=docker/dockerfile:1.6
# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

ARG FROM_IMAGE=sqltools-base:latest
FROM ${FROM_IMAGE} AS base
RUN addgroup -S edfi && adduser -S edfi -G edfi

FROM base AS build
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

# Alpine image does not contain Globalization Cultures library so we need to install ICU library to get for LINQ expression to work
# Disable the globaliztion invariant mode (set in base image)
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false
ENV ASPNETCORE_HTTP_PORTS=8080

WORKDIR /app

COPY --chmod=500 Settings/mssql/mi.run.sh /app/run.sh
COPY Settings/mssql/log4net.config /app/log4net.txt

# Copy shared runtime helpers (sourced by run.sh). Adjust path relative to this Dockerfile.
COPY --from=shared --chmod=544 run-common.sh /opt/run-common.sh

RUN --mount=type=bind,source=app.zip,target=/src/app.zip \
    bash -c 'unzip /src/app.zip AdminApi/* -d /app/'

RUN umask 0077 && \
    cp -r /app/AdminApi/. /app/ && \
    rm -r /app/AdminApi && \
    cp /app/log4net.txt /app/log4net.config && \
    dos2unix /app/*.json && \
    dos2unix /app/*.sh && \
    dos2unix /app/log4net.config && \
    chmod 700 /app/*.sh -- ** && \
    rm -f /app/*.exe && \
    apk del unzip dos2unix && \
    chown -R edfi /app

EXPOSE ${ASPNETCORE_HTTP_PORTS}
USER edfi

ENTRYPOINT [ "/app/run.sh" ]
