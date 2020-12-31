FROM jupyterhub/jupyterhub

COPY fonts/msyh.ttf /tmp/
# add default user
RUN groupadd jupyterhub  \
&& useradd -g jupyterhub -m jupyter \
&& echo "jupyter:123456" | chpasswd \
&& pip install notebook matplotlib numpy pandas opencv-python moviepy Pillow \
&& apt-get update  \
&& apt-get -yq install  ttf-mscorefonts-installer fontconfig \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* \
&& mkdir /usr/share/fonts/winFonts \
&& cp /tmp/msyh.ttf /usr/share/fonts/winFonts/ \
&& chmod 644 /usr/share/fonts/winFonts/*.ttf \
&& cd /usr/share/fonts/winFonts \
&& mkfontscale \
&& mkfontdir \
&& fc-cache -fv


EXPOSE 8000
