FROM ubuntu:18.04

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i -r 's|(archive\|security)\.ubuntu\.com/|ftp.jaist.ac.jp/pub/Linux/|' /etc/apt/sources.list && apt-get update && apt-get install -y python-pip && \
#RUN apt-get update && apt-get install -y python-pip && \
    apt-get upgrade -y && \
    apt-get install -y build-essential apt-utils ca-certificates \
    cmake git libgtk2.0-dev pkg-config \
    libswscale-dev wget autoconf automake pkg-config unzip curl \
    python-dev python-numpy python3 python3-pip python3-dev \
    ffmpeg libavcodec-dev libavformat-dev libavresample-dev \
    libjpeg-dev libdc1394-22-dev libv4l-dev \
    python-opencv libopencv-dev python-pycurl \
    libpng-dev libswscale-dev libtbb-dev libtiff-dev \ 
    libatlas-base-dev gfortran webp qt5-default libvtk6-dev zlib1g-dev \
    libxml2-dev libxslt1-dev zlib1g-dev emacs && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
ENV OPENCV_VERSION="3.4.3"
RUN mkdir -p /app/opencv-$OPENCV_VERSION/build

RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
    unzip ${OPENCV_VERSION}.zip

WORKDIR /app/opencv-$OPENCV_VERSION/build
RUN cmake -DWITH_TBB=ON \
    -DWITH_EIGEN=ON \
    -DWITH_V4L=ON \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DPYTHON_EXECUTABLE=$(which python) \
    -DPYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
    -DPYTHON_PACKAGES_PATH=$(python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
     .. 

RUN make -j install && \
    rm /app/${OPENCV_VERSION}.zip && \
    rm -r /app/opencv-${OPENCV_VERSION}

WORKDIR /app
COPY . /app

RUN mkdir -p /etc/udev/rules.d
    
RUN ./install_zense_sdk.sh

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/root/.local/lib:/usr/local/lib
ENV PATH $PATH:/root/.local/bin

RUN ./install_zwrapper.sh

CMD [ "./docker-entrypoint.sh" ]
