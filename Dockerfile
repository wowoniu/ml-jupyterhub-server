FROM jupyterhub/jupyterhub
MAINTAINER qiang <zhiqiangvip999@gmail.com>

# add default user
RUN groupadd jupyterhub 
RUN useradd -g jupyterhub -m jupyter
RUN echo "jupyter:123456" | chpasswd
RUN pip install notebook

# install numpy pandas 
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        python-opencv && \
        rm -rf /var/lib/apt/lists/*
RUN pip install matplotlib numpy pandas opencv-python moviepy Pillow
EXPOSE 8000
