#!/bin/bash

# DOWNLOAD_URL=""
# SET DOWNLOAD_URL VARIABLE BEFORE RUNNING THIS


             FLV_OUTPUT_FIL=$(
                              youtube-dl                                          \
                              --username="${GMAIL_USERNAME}"                      \
                              --password="${GMAIL_PASSWORD}"                      \
                              -e "${DOWNLOAD_URL}"                                \
                                 |                                                \
                                 sed                                              \
                                    -e s,"[^a-zA-Z0-9_ /]",,g                     \
                                    -e s,"  *"," ",g                              \
                                    -e s," ","",g                                 \
                                    -e s,"/","",g                                 \
                                    -e s,"_","-",g                                \
                                    -e s,$,.flv,g
                             )

youtube-dl --output="${FLV_OUTPUT_FIL}" "${DOWNLOAD_URL}"
