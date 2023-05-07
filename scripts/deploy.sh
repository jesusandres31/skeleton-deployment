#!/bin/bash

deploy() {
  local sudo_cmd=""
  
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    sudo_cmd="sudo "
  elif [[ "$OSTYPE" == "msys" ]]; then
    sudo_cmd=""
  elif [[ "$OSTYPE" == "darwin" ]]; then
    sudo_cmd=""
  else
    echo "Cannot determine operating system."
    return 1
  fi

  pwd 

  echo "Stopping containers:"
  "${sudo_cmd}"docker-compose down  

  echo "About to pull containers:"
  "${sudo_cmd}"docker-compose pull

  echo "About to start containers:"
  docker-compose --env-file ../../config/.env up --build -d

  # echo "Cleaning up dangling images:"
  # "${sudo_cmd}"docker image prune -af
  
  echo "Done!"
}

while getopts ":psd" opt; do
  case $opt in
    p)
      echo "Start PRODUCTION env..."
      cd environments/production
      deploy
      ;;
    s)
      echo "Start STAGING env..."
      cd environments/staging
      deploy
      ;;
    d)
      echo "Start DEVELOPMENT env..."
      cd environments/development
      deploy
      ;;
    \?)
      echo "Invalid Option: -$OPTARG"
      exit 1
      ;;
  esac
done