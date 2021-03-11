FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /DDTVLiveRec
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone  \
    && apt update \
    && apt install --no-install-recommends ffmpeg -y \
    && apt-get clean -y  \
    && rm -rf /var/lib/apt/lists/* \
    && DDTVLiveRec_RELEASE=$(curl -sX GET https://api.github.com/repos/CHKZL/DDTV2/releases/latest | awk '/tag_name/{print $5;exit}' FS='[r"]') \
    && wget https://github.com/CHKZL/DDTV2/releases/latest/download/DDTVLiveRec-${DDTVLiveRec_RELEASE}.zip \
    && unzip DDTVLiveRec-*.zip \
    && rm DDTVLiveRec-*/DDTVLiveRec/*.exe DDTVLiveRec-*/DDTVLiveRec/*.txt \
    && mv DDTVLiveRec-*/DDTVLiveRec/* /DDTVLiveRec \
    && rm -rf DDTVLiveRec-*
EXPOSE 11419
VOLUME /DDTVLiveRec/tmp
VOLUME /DDTVLiveRec/BiliUser.ini
VOLUME /DDTVLiveRec/RoomListConfig.json
ENTRYPOINT ["dotnet", "DDTVLiveRec.dll"]