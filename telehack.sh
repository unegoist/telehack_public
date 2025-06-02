#!/bin/bash

# Check if the key file exists in ~/.ssh/
if [ -f "$HOME/.ssh/[name]_telehack" ]; then

  # Create a timestamp for the log filename
  timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

  # Log all input and output to a file named telehack-log_[timestamp].log
  exec > >(tee -a "/home/[name]/telehack/telehack_log/telehack-log_${timestamp}.log") 2>&1
  
  # Prompt the user for confirmation
  read -p "Proceed with SSH connection? (y/n): " -r response

  # Check the user's response
  case "$response" in
  y | Y)
    echo "Use your time wisely."
    echo "Connecting..."
    # Record the start time
    start_time=$(date +%s)
    ;;
  n | N)
    echo "Connection aborted."
    exit 0
    ;;
  *)
    echo "Invalid input. Please enter 'y' or 'n'."
    exit 1
    ;;
  esac

  # Connect to the server
  user="[name]"
  port=2222
  key_file="$HOME/.ssh/[name]_telehack"
  server="telehack.com"

  # Attempt to connect and handle potential errors
  ssh -l "${user}" -p "${port}" -i "${key_file}" "${server}"

  # Record the end time
  end_time=$(date +%s)

  # Calculate the time spent
  elapsed_time=$((end_time - start_time))

  # Log the session duration
  echo "Session duration: $(($elapsed_time / 60)) minutes and $((elapsed_time % 60)) seconds" >>"/home/[name]/telehack/telehack_log/telehack-log_${timestamp}.log"

  # Upload log file to repository
  cd telehack
  git add -A
  git commit -m "upload log file ${timestamp}"
  git push -u origin main
  exit 0

else
  echo "Error: [name]_telehack file not found in ~/.ssh/."
  exit 1
fi
