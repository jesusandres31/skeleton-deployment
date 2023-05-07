#!/bin/sh
source ./config/.env

# Check if environment variables are set
if [ -z "$REPO_NAME" ] || [ -z "$USERNAME" ] || [ -z "$BRANCH" ]; then
  echo "ERROR: Environment variables not set"
  exit 1
fi

# Git pull function
git_pull(){
    pwd 
    git checkout ${BRANCH}
    git pull 
    git branch
}

# Define function to push an image to a registry
push_image() {
  local img_name=$1
  local img_path=$2
  local img_id
 
  cd "../$1"

  git_pull

  docker build -t="${img_name}" .

  # Check if the image exists before tagging and pushing it
  if img_id=$(docker images --format "{{.ID}} {{.Repository}}" | grep "${img_name}"  | head -n1 | awk '{ print $1 }'); then
    if [ -n "${img_id}" ] && [ -n "${img_path}" ]; then
      echo "ABOUT TO TAG "${img_id}" TO "${img_path}""
      docker tag "${img_id}" "${img_path}"
      echo "ABOUT TP PUSH "${img_path}""
      docker push "${img_path}"
    else
      echo "ERROR: Failed to get image ID or path for ${img_name}"
      exit 1
    fi
  else
    echo "ERROR: Failed to find Docker image ${img_name}"
    exit 1
  fi

  cd -
}
 
# Push back image
push_image "${REPO_NAME}-back" "registry.gitlab.com/${USERNAME}/${REPO_NAME}/back:latest"

# Push front image
push_image "${REPO_NAME}-front" "registry.gitlab.com/${USERNAME}/${REPO_NAME}/front:latest"

# Finish
echo "Done!"