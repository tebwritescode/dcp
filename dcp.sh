#!/bin/bash

# Check how many arguments were passed
if [ $# -eq 0 ]; then
    # No arguments passed
    IMAGE_NAME=$(basename "$PWD")
    DOCKER_IMAGE_NAME=$(basename "$PWD")
elif [ $# -eq 1 ]; then
    # One argument passed
    IMAGE_NAME=$(basename "$PWD")
    DOCKER_IMAGE_NAME=$1
elif [ $# -eq 2 ]; then
    # Two arguments passed
    IMAGE_NAME=$1
    DOCKER_IMAGE_NAME=$2
else
    echo "Error: Too many arguments passed."
    echo "Usage: $0 - Use parent directory name for both local and docker image name."
    echo "$0 <DOCKER_IMAGE_NAME> - Use parent directory name for local image name and use <DOCKER_IMAGE_NAME> as docker image name/"
    echo "$0 <IMAGE_NAME> <DOCKER_IMAGE_NAME> - Use <IMAGE_NAME> for local image name and use <DOCKER_IMAGE_NAME> as docker image name/"
    exit 1
fi

# Get today's date in the format MM.DD.YY
DATE=$(date +"%m.%d.%y")

# Define the file where the counter will be stored
COUNTER_FILE="/opt/dockerpush/counters/build_counter_${DOCKER_IMAGE_NAME}_${DATE}.txt"

# Check if the counter file exists, if not, create it and set the counter to 0
if [ ! -f "$COUNTER_FILE" ]; then
    rm -fv build_counter_${DOCKER_IMAGE_NAME}_*.txt
    echo "0" > "$COUNTER_FILE"
fi

# Read the current counter value
COUNTER=$(cat "$COUNTER_FILE")

# Increment the counter by 1
NEW_COUNTER=$((COUNTER + 1))

# Update the counter in the file
echo "$NEW_COUNTER" > "$COUNTER_FILE"

# Build the Docker image with the version tag in the format MM.DD.YY.<counter>
if ! /usr/bin/docker build -t "$IMAGE_NAME":"$DATE"."$NEW_COUNTER" .; then
    echo "Docker build failed."
    exit 1
fi

# Print the image tag for reference
echo "Docker image built with tag: $IMAGE_NAME:$DATE.$NEW_COUNTER"

# Tag the image for DockerHub
/usr/bin/docker tag "$IMAGE_NAME:$DATE.$NEW_COUNTER" tebwritescode/"$DOCKER_IMAGE_NAME:$DATE.$NEW_COUNTER"
/usr/bin/docker tag "$IMAGE_NAME:$DATE.$NEW_COUNTER" tebwritescode/"$DOCKER_IMAGE_NAME:latest"

# Print the image tag for reference
echo "Docker image tagged: tebwritescode/$DOCKER_IMAGE_NAME:$DATE.$NEW_COUNTER"
echo "Docker image tagged: tebwritescode/$DOCKER_IMAGE_NAME:latest"

# Push the Docker image to DockerHub
if ! /usr/bin/docker push tebwritescode/"$DOCKER_IMAGE_NAME:$DATE.$NEW_COUNTER"; then
    echo "Docker push failed for $NEW_COUNTER."
    exit 1
fi

if ! /usr/bin/docker push tebwritescode/"$DOCKER_IMAGE_NAME:latest"; then
    echo "Docker push failed for 'latest'."
    exit 1
fi

# Output the assigned values (optional)
echo "Local Image Name: $IMAGE_NAME"
echo "Docker Image Name: $DOCKER_IMAGE_NAME"

# Print the image push for reference
echo "Docker image pushed: tebwritescode/$DOCKER_IMAGE_NAME:$DATE.$NEW_COUNTER"
echo "Docker image pushed: tebwritescode/$DOCKER_IMAGE_NAME:latest"
