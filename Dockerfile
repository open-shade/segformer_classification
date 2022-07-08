ARG ROS_VERSION
FROM shaderobotics/ros:${ROS_VERSION}

ARG ROS_VERSION
ENV ROS_VERSION=$ROS_VERSION

ARG ORGANIZATION
ARG MODEL_VERSION

ENV MODEL_NAME="$ORGANIZATION"/"$MODEL_VERSION"

WORKDIR /home/shade/shade_ws


RUN apt update && \
    apt install -y curl && \
    sh -c 'echo "deb [arch=amd64,arm64] http://repo.ros2.org/ubuntu/main `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list' && \
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && \
    apt update && \
    apt install -y python3-colcon-common-extensions python3-pip ros-${ROS_VERSION}-cv-bridge ros-${ROS_VERSION}-vision-opencv && \
    echo "#!/bin/bash" >> /home/shade/shade_ws/start.sh && \
    echo "source /opt/shade/setup.sh" >> /home/shade/shade_ws/start.sh && \
    echo "source /opt/ros/${ROS_VERSION}/setup.sh" >> /home/shade/shade_ws/start.sh && \
    echo "source ./install/setup.sh" >> ./start.sh && \
    echo "ros2 run <name>_ros2 <name>_ros2" >> /home/shade/shade_ws/start.sh && \
    chmod +x ./start.sh

COPY . ./src/<name>_ros2

RUN pip3 install ./src/<name>_ros2 && \
    : "Install the model" && \
    python3 -c "from transformers import AutoFeatureExtractor; AutoFeatureExtractor.from_pretrained('${MODEL_NAME}')" && \
    colcon build

ENTRYPOINT ["/home/shade/shade_ws/start.sh"]
