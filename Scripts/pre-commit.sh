#!/bin/bash

function list_staged_files() {
  git diff --cached --name-only --diff-filter=ACM | grep -v "pre-commit.sh"
}

function list_unstaged_files() {
  git diff --name-only --diff-filter=ACM | grep -v "pre-commit.sh"
}

function validation_branch {
  local branch=$1
  echo ""
  echo "Current Branch: $branch"
  echo ""

  if [ "$branch" = "main" ] || [ "$branch" = "develop" ] || [[ "$branch" =~ ^release/ ]]; then
    echo "You can't commit directly to the main, develop, or release branches"
    exit 1
  fi
  echo ""
  echo "The branch is valid, moving onto the next step..."
  echo ""
}

function checkBranchNaming() {
  local branchName="$1"
  local validPrefixes=("feature/" "bugfix/" "hotfix/" "release/")
  
  for prefix in "${validPrefixes[@]}"; do
    if [[ "${branchName,,}" == "$prefix"* ]]; then
      return 0
    fi
  done
  
  echo "Branch name '$branchName' doesn't follow the naming convention. Consider using prefixes like feature/, bugfix/, hotfix/, or release/."
  exit 1
}

function validation_file_changes {
  local allChangedFiles=$1
  local invalidCharRegex='[^a-zA-Z0-9._+/-]'

  for file in $allChangedFiles; do
    echo "Checking file: $file"
    
    if [[ $file =~ $invalidCharRegex ]]; then
      echo "Error: File name $file contains spaces or special characters."
      exit 1
    fi

    if [ -f "$file" ]; then
      local fileSize=$(stat -f%z "$file")
      if (( fileSize > maxSize )); then
        echo "Error: File $file exceeds the size limit of $maxSize bytes."
        exit 1
      fi
    else
      echo "Warning: File $file does not exist."
    fi
  done
}

function check_todos {
  local allChangedFiles=$1
  echo "Checking for TODOs or FIXMEs..."
  
  for file in $allChangedFiles; do
    if grep -qE 'TODO|FIXME' "$file"; then
      echo "Error: TODOs or FIXMEs found in $file."
      exit 1
    fi
  done
}

function check_deprecated_apis {
  local allChangedFiles=$1
  echo "Checking for deprecated API usage..."
  
  for file in $allChangedFiles; do
    if grep -q 'deprecated' "$file"; then
      echo "Error: Deprecated APIs found in $file."
      exit 1
    fi
  done
}

function check_large_binary_files {
  local allChangedFiles=$1

  echo "Checking for large binary files..."
  for file in $allChangedFiles; do
    if [ -f "$file" ]; then
      local fileSize=$(stat -f%z "$file")
      if (( fileSize > maxBinarySize )); then
        echo "Error: Binary file $file exceeds the size limit of $maxBinarySize bytes."
        exit 1
      fi
    fi
  done
}

function check_merge_conflicts {
  local allChangedFiles=$1
  echo "Checking for merge conflict markers..."

  for file in $allChangedFiles; do
    if grep -qE '<<<<<<|======|>>>>>>' "$file"; then
      echo "Error: Merge conflict markers found in $file."
      exit 1
    fi
  done
}

function check_sensitive_information {
  local allChangedFiles=$1
  echo "Checking for sensitive information..."

  for file in $allChangedFiles; do
    if grep -qE 'API_KEY|SECRET|PASSWORD' "$file"; then
      echo "Error: Sensitive information found in $file."
      exit 1
    fi
  done
}

function main {
  branch=$(git rev-parse --abbrev-ref HEAD)
  localStagedFiles=$(list_staged_files)
  localUnstagedFiles=$(list_unstaged_files)
  allChangedFiles=$(echo -e "$localStagedFiles\n$localUnstagedFiles" | sort -u | grep -v "Dangerfile.swift")

  checkBranchNaming "$branch"
  validation_branch "$branch"
  validation_file_changes "$allStagedFiles"
  check_todos "$allStagedFiles"
  check_deprecated_apis "$allStagedFiles"
  check_large_binary_files "$allStagedFiles"
  check_merge_conflicts "$allStagedFiles"
  check_sensitive_information "$allStagedFiles"
}

echo "*********************************************************"
echo "Running git pre-commit hook. Making sure that it pass validation..."
echo "*********************************************************"
maxSize=1048576
maxBinarySize=5242880
main
echo ""
echo "Pre-commit checks completed successfully."
echo ""
