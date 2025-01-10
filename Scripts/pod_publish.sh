#!/bin/bash

function get_current_version {
  local PODSPEC_FILE="$1"
  local CURRENT_VERSION=$(grep -E "^ *spec.version" "${PODSPEC_FILE}" | sed -E 's/.*"(.+)".*/\1/')
  echo "${CURRENT_VERSION}"
}

function increment_version {
  local CURRENT_VERSION="$1"
  local MAJOR=$(echo "${CURRENT_VERSION}" | cut -d. -f1)
  local MINOR=$(echo "${CURRENT_VERSION}" | cut -d. -f2)
  local PATCH=$(echo "${CURRENT_VERSION}" | cut -d. -f3)
  
  PATCH=$((PATCH + 1))
  
  local NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
  echo "${NEW_VERSION}"
}

function update_podspec_version {
  local PODSPEC_FILE="${POD_NAME}.podspec"
  local NEW_VERSION="$2"
  if [ ! -f "$PODSPEC_FILE" ]; then
    echo "🍎🍎🍎 Error: ${PODSPEC_FILE} not found." >&2
    exit 1
  fi
  sed -i "" "s/spec.version      = \".*\"/spec.version      = \"${NEW_VERSION}\"/" "${PODSPEC_FILE}"
}

function commit_changes {
  local POD_NAME=$1
  local NEW_VERSION=$2
  local BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

  git add .
  git commit -m "Auto update ${POD_NAME} and related pods to version ${NEW_VERSION}"
  git push -f origin $BRANCH_NAME
}

function tag_commit {
  local POD_NAME=$1
  local NEW_VERSION=$2
  local FULL_TAG="${POD_NAME}-${NEW_VERSION}"
  
  git tag "$FULL_TAG"
  git push -f origin "$FULL_TAG"
}

function push_podspec {
  local POD_NAME=$1
  local PODSPEC_FILE="${POD_NAME}.podspec"
  
  if pod repo push Specs "${PODSPEC_FILE}" --allow-warnings --verbose; then
    echo "🍏🍏🍏 Successfully pushed ${POD_NAME} podspec to Specs repo."
  else
    echo "🍎🍎🍎 Failed to push ${POD_NAME} podspec to Specs repo."
    echo "Please provide [POD_SPEC_REPO] and [POD_SPEC_REPO_URL] and use this command:"
    exit 1
  fi
}

function publish_podspec {
  local BASE_POD_NAME=$1
  local NEW_VERSION=$2

  local POD_NAMES=("${BASE_POD_NAME}")

  if [ -f "${BASE_POD_NAME}Mock.podspec" ]; then
    POD_NAMES+=("${BASE_POD_NAME}Mock")
  fi

  if [ -f "${BASE_POD_NAME}Imp.podspec" ]; then
    POD_NAMES+=("${BASE_POD_NAME}Imp")
  fi
  
  for POD_NAME in "${POD_NAMES[@]}"; do
    update_podspec_version "$POD_NAME" "$NEW_VERSION"
  done
  
  commit_changes "$BASE_POD_NAME" "$NEW_VERSION"
  tag_commit "$BASE_POD_NAME" "$NEW_VERSION"

  for POD_NAME in "${POD_NAMES[@]}"; do
     push_podspec "$POD_NAME"
  done
}

function pre_validation_podspecs {
  local BASE_POD_NAME=$1
  local NEW_VERSION=$2

  if [[ "$BASE_POD_NAME" =~ "Imp" || "$BASE_POD_NAME" =~ "Mock" ]]; then
    echo "🍎🍎🍎 Error: POD_NAME must not contain 'Imp' or 'Mock'." >&2
    exit 1
  fi
  
  if [[ ! "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "🍎🍎🍎 Error: TAG must be in the format x.y.z (e.g., 1.0.0)." >&2
    exit 1
  fi
}

function auto_pod_deploy {
  BASE_POD_NAME=$1
  if [ $ARG_COUNT -eq 0 ]; then
    CURRENT_VERSION=$(get_current_version "${BASE_POD_NAME}.podspec")
    NEW_VERSION=$(increment_version "$CURRENT_VERSION")
    echo "🤖🤖🤖 $BASE_POD_NAME auto-incrementing version from $CURRENT_VERSION to $NEW_VERSION "
  elif [ $ARG_COUNT -eq 1 ]; then
    NEW_VERSION=$1
    echo "🤖🤖🤖 $BASE_POD_NAME manually update version to $NEW_VERSION"
  else
    echo "🍎🍎🍎 Error: too many arguments. We only support 0 or 1 argument"
    exit 1
  fi
  pre_validation_podspecs "$BASE_POD_NAME" "$NEW_VERSION"
  publish_podspec "$BASE_POD_NAME" "$NEW_VERSION"
}

function main() {
  ARG_COUNT=$#
  POD_DEPLOY_FILE="$(dirname "$0")/pod_deploy_name.txt"

  if [[ -f "$POD_DEPLOY_FILE" ]]; then
    LIS_DEPLOY_LIBRARY_NAME=()
    while IFS= read -r line; do
      LIS_DEPLOY_LIBRARY_NAME+=("$line")
    done < "$POD_DEPLOY_FILE"

    for LIBRARY_NAME in "${LIS_DEPLOY_LIBRARY_NAME[@]}"; do
      if [[ -n "$LIBRARY_NAME" ]]; then
        auto_pod_deploy "$LIBRARY_NAME"
      fi
    done
  else
    echo "File not found: $POD_DEPLOY_FILE"
  fi
}

main "$@"

exit 0
