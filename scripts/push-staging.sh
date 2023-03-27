#!/bin/sh

#
REPO_NAME=someapp
USERNAME=someuser
BRANCH=master

#
BACK_IMG_NAME=someapp-backend
BACK_IMG_PATH=registry.gitlab.com/${USERNAME}/someapp/backend:latest

FRONT_IMG_NAME=someapp-frontend
FRONT_IMG_PATH=registry.gitlab.com/${USERNAME}/someapp/frontend:latest

#
# functins
#

# git pull
git_pull(){
    git checkout ${BRANCH}

    git pull 

    git branch
}

#
# start...
#

#
# back
#
cd ../../../someapp-backend

# git pull
git_pull

# docker image prune -af
docker build -t="${BACK_IMG_NAME}" .

# get just created image ID
BACK_IMG_ID=$(docker images --format "{{.ID}} {{.Repository}}" | grep ${BACK_IMG_NAME} | awk '{ print $1 }')

docker tag ${BACK_IMG_ID} ${BACK_IMG_PATH}

docker push ${BACK_IMG_PATH}

#
# front
#
cd ../someapp-frontend

# git pull
git_pull

# docker image prune -af
docker build -t="${FRONT_IMG_NAME}" .

# get just created image ID
FRONT_IMG_ID=$(docker images --format "{{.ID}} {{.Repository}}" | grep ${FRONT_IMG_NAME} | awk '{ print $1 }')

docker tag ${FRONT_IMG_ID} ${FRONT_IMG_PATH}

docker push ${FRONT_IMG_PATH}

# end...