ARG DISTRIB=debian
ARG VERSION=latest
FROM ${DISTRIB}:${VERSION}

LABEL maintainer="camille.perin@protonmail.com"

#RUN apt-get update && apt-get -y --no-install-recommends install apt-utils
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        binutils \
        ca-certificates \
	cmake \
	cmake-curses-gui \
        g++ \
        gcc \
        git \
	libeigen3-dev \
	libgmp-dev \
	libmpfr-dev \
	libpython3-dev \
	libz-dev \
	libboost-thread-dev \
	libboost-system-dev \
	libtbb-dev \
	make \
	python3 \
	python3-pip \
	python3-setuptools \
	swig \
	wget \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN git clone https://github.com/CGAL/cgal
RUN git clone https://github.com/cgal/cgal-swig-bindings

RUN mkdir -p build
WORKDIR build

RUN cmake -DCGAL_DIR=../cgal -DBUILD_PYTHON=ON -DBUILD_JAVA=OFF -DCMAKE_BUILD_TYPE=Release ../cgal-swig-bindings
RUN make

ENV PYTHONPATH=/app/build/build-python:$PYTHONPATH
WORKDIR /notebooks
RUN useradd --create-home --shell /bin/bash cgal-user
USER cgal-user
ENV PATH /home/cgal-user/.local/bin:$PATH
RUN pip3 install --user wheel
RUN pip3 install --user jupyterlab

CMD [ "jupyter-lab" , "--ip=0.0.0.0", "--port=8181" ]
