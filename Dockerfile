FROM jupyterhub/jupyterhub

# add default user
RUN groupadd jupyterhub  \
&& useradd -g jupyterhub -m jupyter \
&& echo "jupyter:123456" | chpasswd \
&& pip install notebook matplotlib numpy pandas opencv-python moviepy Pillow \
&& apt-get update  \
&& apt-get -yq install  python-opencv \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

EXPOSE 8000
