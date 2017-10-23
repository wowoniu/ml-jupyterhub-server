FROM jupyterhub/jupyterhub
MAINTAINER qiang <zhiqiangvip999@gmail.com>

# add user
RUN groupadd jupyterhub 
RUN useradd -g jupyterhub -m jupyter
RUN echo "jupyter:123456" | chpasswd
RUN pip install notebook

EXPOSE 8000
