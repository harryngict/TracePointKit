#!/bin/bash

function main() {
  echo "Choose deployment option:"
  echo "1: Publish for SPM"
  echo "2: Publish for Cocoapods"
  echo "3: Publish for both SPM and Cocoapods"

  read -p "Enter your choice (1/2/3): " choice

  case $choice in
    1)
      echo "You selected: Publish for SPM"
      handle_spm_publish
      ;;
    2)
      echo "You selected: Publish for Cocoapods"
      handle_cocoapods_publish
      ;;
    3)
      echo "You selected: Publish for both SPM and Cocoapods"
      handle_spm_publish
      handle_cocoapods_publish
      ;;
    *)
      echo "Invalid choice. Exiting."
      exit 1
      ;;
  esac
}

function handle_spm_publish() {
  read -p "SPM choose an publish option: (1) Automatic or (2) Manual: " spm_option
  case $spm_option in
    1)
      Scripts/spm_publish.sh
      ;;
    2)
      read -p "Enter the version to deploy: " version
      Scripts/spm_publish.sh "$version"
      ;;
    *)
      echo "Invalid option for SPM. Exiting."
      exit 1
      ;;
  esac
}

function handle_cocoapods_publish() {
  read -p "Cocoapods choose an publish option: (1) Automatic or (2) Manual: " cocoapod_option
  case $cocoapod_option in
    1)
      Scripts/pod_publish.sh
      ;;
    2)
      read -p "Enter the version to deploy: " version
      Scripts/pod_publish.sh "$version"
      ;;
    *)
      echo "Invalid option for Cocoapods. Exiting."
      exit 1
      ;;
  esac
}

main
