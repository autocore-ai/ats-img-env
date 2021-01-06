ARG FROM_IMAGE
FROM ${FROM_IMAGE}

RUN apt-get update \
    && rosdep init \
    && rosdep update --rosdistro=${ROS_DISTRO} \
    && apt-get install -q -y --no-install-recommends \
    geographiclib-tools \
    python3-pip \
    ros-${ROS_DISTRO}-ros-core \
    && rm -rf /var/lib/apt/lists/*

RUN git clone -b v2.3.0 --depth 1 --recursive https://github.com/Livox-SDK/Livox-SDK.git /livox_sdk \
    && mkdir -p /livox_sdk/build \
    && cd /livox_sdk/build \
    && cmake .. \
    && make \
    && make install \
    && rm -rf /livox_sdk

RUN pip install wheel gdown future

RUN geographiclib-get-geoids egm2008-1

COPY ./ros_entrypoint.sh /
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]