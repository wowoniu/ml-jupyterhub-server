ARG BASE_IMAGE=ubuntu:focal-20200729@sha256:6f2fb2f9fb5582f8b587837afd6ea8f37d8d1d9e41168c90f410a6ef15fa8ce5
FROM $BASE_IMAGE AS builder

USER root

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
 && apt-get install -yq --no-install-recommends \
    build-essential \
    ca-certificates \
    locales \
    python3-dev \
    python3-pip \
    python3-pycurl \
    nodejs \
    npm \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade setuptools pip wheel

# copy everything except whats in .dockerignore, its a
# compromise between needing to rebuild and maintaining
# what needs to be part of the build
COPY . /src/jupyterhub/
WORKDIR /src/jupyterhub

# Build client component packages (they will be copied into ./share and
# packaged with the built wheel.)
RUN python3 setup.py bdist_wheel
RUN python3 -m pip wheel --wheel-dir wheelhouse dist/*.whl


FROM $BASE_IMAGE

USER root

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -yq --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    locales \
    python3-pip \
    python3-pycurl \
    nodejs \
    npm \
    python-opencv \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

RUN  locale-gen $LC_ALL \
&& python3 -m pip install --no-cache --upgrade setuptools pip \
&& npm install -g configurable-http-proxy@^4.2.0 \
&& rm -rf ~/.npm


# install the wheels we built in the first stage
COPY --from=builder /src/jupyterhub/wheelhouse /tmp/wheelhouse
RUN python3 -m pip install --upgrade pip \
&& python3 -m pip install --no-cache /tmp/wheelhouse/* \
&& mkdir -p /srv/jupyterhub/ \
&& groupadd jupyterhub && \
&& useradd -g jupyterhub -m jupyter \
&& echo "jupyter:123456" | chpasswd  \
&& pip install notebook matplotlib numpy pandas opencv-python moviepy Pillow 

WORKDIR /srv/jupyterhub/

EXPOSE 8000

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"
LABEL org.jupyter.service="jupyterhub"

CMD ["jupyterhub"]
