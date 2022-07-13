# SegFormer-ROS2 Wrapper

This is a ROS2 wrapper for the Simple Efficient Design for Semantic Segmentation for Transformers with an image classification head, [SegFormer](https://arxiv.org/abs/2105.15203). We utilize `huggingface` and the `transformers` for the [source of the algorithm](https://huggingface.co/nvidia/mit-b3). The main idea is for this container to act as a standalone interface and node, removing the necessity to integrate separate packages and solve numerous dependency issues. We have built all different versions of the algorithm (i.e. `base-patch16-224`, `large-patch16-224`, etc.) for each ROS2 distribution.

*From Paper:* SegFormer has two appealing features: 1) SegFormer comprises a novel hierarchically structured Transformer encoder which outputs multiscale features. It does not need positional encoding, thereby avoiding the interpolation of positional codes which leads to decreased performance when the testing resolution differs from training. 2) SegFormer avoids complex decoders. The proposed MLP decoder aggregates information from different layers, and thus combining both local attention and global attention to render powerful representations. The paper shows that this simple and lightweight design is the key to efficient segmentation on Transformers.

Model has been pre-trained and finetuned on the ImageNet-1K dataset

# Installation Guide

## Using Docker Pull
1. Install [Docker](https://www.docker.com/) and ensure the Docker daemon is running in the background.
2. Run ```docker pull shaderobotics/segformer:${ROS2_DISTRO}-${MODEL_VERSION}``` we support all ROS2 distributions along with all model versions found in the model version section below.
3. Follow the run commands in the usage section below

## Build Docker Image Natively
1. Install [Docker](https://www.docker.com/) and ensure the Docker daemon is running in the background.
2. Clone this repo with ```git pull https://github.com/open-shade/segformer.git```
3. Enter the repo with ```cd segformer```
4. To pick a specific model version, edit the `ALGO_VERSION` constant in `/segformer/segformer.py`
5. Build the container with ```docker build . -t [name]```. This will take a while. We have also provided associated `cloudbuild.sh` scripts to build on GCP all of the associated versions.
6. Follow the run commands in the usage section below.

# Model Versions

* ```b0```
* ```b1```
* ```b2```
* ```b3```
* ```b4```
* ```b5```

More information about these versions can be found in the [paper](https://arxiv.org/abs/2105.15203). Size of the model increases with the number.

## Example Docker Command

```bash
docker pull shaderobotics/segformer:foxy-b0
```

# Usage
## Run the DEIT Node 
Run ```docker run -t --net=host shaderobotics/segformer:${ROS_DISTRO}-${MODEL_VERSION}```. Your node should be running now. Then, by running ```ros2 topic list,``` you should see all the possible pub and sub routes.

For more details explaining how to run Docker images, visit the official Docker documentation [here](https://docs.docker.com/engine/reference/run/). Also, additional information as to how ROS2 communicates between external environment or multiple docker containers, visit the official ROS2 (foxy) docs [here](https://docs.ros.org/en/foxy/How-To-Guides/Run-2-nodes-in-single-or-separate-docker-containers.html#). 

# Topics

| Name                   | IO  | Type                             | Use                                                               |
|------------------------|-----|----------------------------------|-------------------------------------------------------------------|
| segformer/image_raw       | sub | [sensor_msgs.msg.Image](http://docs.ros.org/en/noetic/api/sensor_msgs/html/msg/Image.html)            | Takes the raw camera output to be processed                       |
 | segformer/result           | pub | String            | Outputs the classification label from ImageNet 100 Classes as a string |

# Testing / Demo
To test and ensure that this package is properly installed, replace the Dockerfile in the root of this repo with what exists in the demo folder. Installed in the demo image contains a [camera stream emulator](https://github.com/klintan/ros2_video_streamer) by [klintan](https://github.com/klintan) which directly pubs images to the SegFormer node and processes it for you to observe the outputs.

To run this, run ```docker build . -t [name]```, then ```docker run --net=host -t [name]```. Observing the logs for this will show you what is occuring within the container. If you wish to enter the running container and preform other activities, run ```docker ps```, find the id of the running container, then run ```docker exec -it [containerId] /bin/bash```