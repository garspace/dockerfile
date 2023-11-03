FROM nvidia/cuda:12.0.0-cudnn8-runtime-ubuntu22.04
RUN apt-get update && apt-get install -y  \
    vim \
    unzip \
    cmake \
    gcc \
    findutils \
    autoconf \
    wget \
    openssh-client \
    htop \
    openssh-server \
    git \
    libgl1-mesa-glx \
    language-pack-zh-hans \
    locales \
    && rm -rf /var/lib/apt/lists/*

ENV LC_ALL zh_CN.UTF-8

RUN mkdir -p /root/.vim
COPY .vim/plugin /root/.vim/plugin
COPY .vimrc /root/.vimrc
COPY .condarc /root/.condarc

COPY Anaconda3-2022.10-Linux-x86_64.sh .
RUN bash -c '/bin/echo -e "\nyes\n\nyes\nno\nno\nno\nno" | bash Anaconda3-2022.10-Linux-x86_64.sh'
ENV PATH=$PATH:/root/anaconda3/bin
#RUN pip install pycuda
RUN pip install Pillow \
    opencv-python \
    requests \
    scikit-learn \
    yacs \
    tqdm \
    kafka-python \
    protobuf==3.20 \
    -i  https://pypi.tuna.tsinghua.edu.cn/simple 
    
RUN pip install   torch \
    tensorflow \
    pyyaml  \
    tensorrt \
    onnx \
    onnxruntime-gpu \
    addict \
    yapf \
    terminaltables \
    tensorboard \
    lxml \
    ftfy \
    timm \
    diffdist \
    einops \
    pycocotools \
    matplotlib \
    regex \
    transformers \
    FrEIA \
    openpyxl \
    seaborn -i https://pypi.tuna.tsinghua.edu.cn/simple

# TensorRT=8.6
COPY TensorRT-8.6.0.12.Linux.x86_64-gnu.cuda-11.8.tar.gz /tmp
RUN tar xvf /tmp/TensorRT-8.6.0.12.Linux.x86_64-gnu.cuda-11.8.tar.gz -C /opt && rm /tmp/* && rm Anaconda3-2022.10-Linux-x86_64.sh
RUN export LD_LIBRARY_PATH=/opt/TensorRT-8.6.0.12/targets/x86_64-linux-gnu/lib:/opt/TensorRT-8.6.0.12/lib/:/usr/lib/x86_64-linux-gnu:/usr/local/cuda/lib64:$LD_LIBRARY_PATH

RUN pip install nvidia-pyindex 
RUN pip install pytorch-quantization
