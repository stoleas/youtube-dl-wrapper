#!/bin/bash

function aaYOUTUBE_TO_MP3 {
   USER_INPUT="${@}"
   
   FLV_OUTPUT_LOC="/auto/tmp"
   MP3_OUTPUT_LOC="/web/music"
   
   
   # DON'T TOUCH ###############################################################
   for DOWNLOAD_URL in ${USER_INPUT}
   do
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
             MP3_OUTPUT_FIL="${FLV_OUTPUT_FIL/.flv/.mp3}"
      DOWNLOAD_TMP_FLV_FILE="${FLV_OUTPUT_LOC}/${FLV_OUTPUT_FIL}"
      DOWNLOAD_TMP_MP3_FILE="${MP3_OUTPUT_LOC}/${MP3_OUTPUT_FIL}"
      
      # Lists the python scripts in youtube_dl
      # unzip -l $( which youtube-dl )
      
      # Install youtube-dl ###########################################################
      #eval "$( wget --no-check-certificate  -O - "http://rg3.github.io/youtube-dl/download.html" 2>/dev/null | grep "sudo wget" -A 1  |   sed    -e s,"<BR>","\n",gI  -e s,"<[^>]*>",,g  -e s,"wget ","wget --no-check-certificate ",g | head -n 2 )"
      
      # Install ffmpeg ###############################################################
      # sudo apt-get install  ffmpeg  $( sudo apt-cache dump | grep "^Pack.*libavcodec-extra-[0-9][0-9]*" | sort | tail -n 1 | sed s,".   *  ",,g )
      
      #
      #youtube-dl                                         \
      #   ${YTDL_USERNAME:+--username=${YTDL_USERNAME}}   \
      #   ${YTDL_PASSWORD:+--password=${YTDL_PASSWORD}}   \
      #   --output="${YTDL_OUTPUT_FLV}"   "${YTDL_CUR_URL}"
      
      # Downloads
      youtube-dl                                                                  \
         --username="${GMAIL_USERNAME}"                                           \
         --password="${GMAIL_PASSWORD}"                                           \
         --output="${DOWNLOAD_TMP_FLV_FILE}"                                      \
                  "${DOWNLOAD_URL}"
      
      # Turns FLV into MP3
      ffmpeg                                                                      \
         -i      "${DOWNLOAD_TMP_FLV_FILE}"                                       \
         -acodec libmp3lame                                                       \
         -ac     2                                                                \
         -ab     128k                                                             \
         -vn                                                                      \
         -y      "${DOWNLOAD_TMP_MP3_FILE}"
      
      # Validates that the mp3 file has been created
      # If it has been created we will remove the FLV_tmp file.
      if [ -f "${DOWNLOAD_TMP_MP3_FILE}" ]
         then
            rm "${DOWNLOAD_TMP_FLV_FILE}"
            echo -e "#################\n# Successfully created ${DOWNLOAD_TMP_MP3_FILE}"
         else
            echo -e "#################\n# Failed to create ${DOWNLOAD_TMP_MP3_FILE}"
      fi
   done
}
