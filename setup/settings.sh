#!/usr/bin/env bash

TOOLS_PATH=/p/tools
export TOOLS_PATH

if [[ "$OSTYPE" =~ ^darwin ]];
then
    REPO_DIR=/opt/repos
else
    REPO_DIR=/repos
fi
export REPO_DIR
