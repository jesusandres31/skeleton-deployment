#!/bin/bash
 
stop_containers() {
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
  
  echo "Done!"
}

while getopts ":psd" opt; do
  case $opt in
    p)
      echo "Stop PRODUCTION env..."
      cd environments/production
      stop_containers
      ;;
    s)
      echo "Stop STAGING env..."
      cd environments/staging
      stop_containers
      ;;
    d)
      echo "Stop DEVELOPMENT env..."
      cd environments/development
      stop_containers
      ;;
    \?)
      echo "Invalid Option: -$OPTARG"
      exit 1
      ;;
  esac
done
