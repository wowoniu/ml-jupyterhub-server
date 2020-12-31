FROM python:3


COPY font/msyh.ttf /tmp/
COPY pip.conf /tmp/
COPY sources.list /tmp/
ENV DEBIAN_FRONTEND noninteractive
RUN mkdir ~/.pip \
&& cp /tmp/pip.conf ~/.pip/pip.conf \
&& python3 -m pip install --upgrade pip \
&& python3 -m pip install --upgrade notebook matplotlib numpy pandas jupyterhub ipywidgets \
&& rm /etc/apt/sources.list \
&& cp /tmp/sources.list /etc/apt/sources.list \
&& apt-get update \
&& apt-get -yq install npm nodejs  \
&& npm install -g configurable-http-proxy \
# 增加用户
&& groupadd jupyterhub  \
&& useradd -g jupyterhub -m jupyter \
&& echo "jupyter:123456" | chpasswd  \
# 字体安装
# && apt-get -yq install ttf-mscorefonts-installer fontconfig \
# && mkdir /usr/share/fonts/winFonts \
# && cp /tmp/msyh.ttf /usr/share/fonts/winFonts/ \
# && chmod 644 /usr/share/fonts/winFonts/*.ttf \
# && cd /usr/share/fonts/winFonts \
# && mkfontscale \
# && mkfontdir \
# && fc-cache -fv \
# 清除缓存
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* 


EXPOSE 8000

CMD "jupyterhub"
