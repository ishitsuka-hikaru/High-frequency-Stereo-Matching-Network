ARG CUDA_VERSION=12.0.0
ARG CUDNN_VERSION=8
ARG IMGTYPE=devel
ARG OS=ubuntu20.04
FROM nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_VERSION}-${IMGTYPE}-${OS}
ENV TZ=Asia/Tokyo

# install python env
# hadolint ignore=DL3008
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    # common
    build-essential locales wget curl git sudo software-properties-common \
    # python
    python3-pkg-resources zlib1g-dev libjpeg62-dev libssl-dev \
    zlib1g-dev libsqlite3-dev llvm xz-utils tk-dev libxml2-dev libxmlsec1-dev liblzma-dev \
    libbz2-dev libreadline-dev libncursesw5-dev gcc libffi-dev \
    # OpenCV
    g++-8 libopenblas-dev libgtk2.0-dev pkg-config python-dev python-numpy libgl1-mesa-dev \
    # misc.
    tmux &&\
    # remove cache
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG PYTHON_VERSION=3.10
# hadolint ignore=DL3008
RUN add-apt-repository ppa:deadsnakes/ppa &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python${PYTHON_VERSION} python${PYTHON_VERSION}-venv python${PYTHON_VERSION}-dev \
    python${PYTHON_VERSION}-distutils python${PYTHON_VERSION}-gdbm python${PYTHON_VERSION}-tk \
    python${PYTHON_VERSION}-lib2to3 &&\
    curl -sS https://bootstrap.pypa.io/get-pip.py | python${PYTHON_VERSION} &&\
    update-alternatives --install /usr/bin/python python /usr/bin/python${PYTHON_VERSION} 1 &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

# create ubuntu user
ARG user_name=ubuntu
ARG UID=1000
ARG group_name=ubuntu
ARG GID=1000
RUN groupadd -g ${GID} ${group_name} &&\
    useradd -l -u ${UID} -g ${GID} -d /home/${user_name} --create-home --shell /bin/bash ${user_name} &&\
    echo "${user_name} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers &&\
    chown -R ${user_name}:${group_name} /home/${user_name} &&\
    usermod -aG sudo ubuntu

USER ubuntu
WORKDIR /work
ENV HOME /home/ubuntu

# install poetry
# hadolint ignore=SC2016
RUN curl -sSLk https://install.python-poetry.org | python - &&\
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.bashrc &&\
    $HOME/.local/bin/poetry self update &&\
    $HOME/.local/bin/poetry config virtualenvs.in-project true

CMD ["/bin/bash"]
