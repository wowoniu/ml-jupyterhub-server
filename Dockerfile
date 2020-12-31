FROM jupyterhub/jupyterhub
MAINTAINER qiang <zhiqiangvip999@gmail.com>

# add default user
RUN groupadd jupyterhub && \
    useradd -g jupyterhub -m jupyter && \
    echo "jupyter:123456" | chpasswd && \
    python3 -m pip install --upgrade pip && \
    pip install notebook matplotlib numpy pandas opencv-python moviepy Pillow && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install python-opencv && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 8000
