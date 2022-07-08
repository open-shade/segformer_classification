CONTAINER_NAME=us-docker.pkg.dev/shade-prod/wrappers/resnet-ros2:foxy  # shaderobotics/resnet-ros2

# gcloud builds submit -t $CONTAINER_NAME --timeout=10000
docker build . -t $CONTAINER_NAME --build-arg ROS_VERSION=foxy

echo "Starting container..."
echo "====================="

#sudo docker run -it \
#  -v /dev/shm:/dev/shm --entrypoint=/bin/bash \
#  $CONTAINER_NAME -i

#docker run -a STDOUT \
#  -v /dev/shm:/dev/shm \
#  $CONTAINER_NAME
