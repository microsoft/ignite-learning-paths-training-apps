#!/bin/bash

# Log into Azure with Managed Identity
az login --identity -u $MANAGED_IDENTITY

# Tag Resource Group
az group update --resource-group $RESOURCE_GROUP_NAME --tags ITT-Tracking=$SESSION_CODE CreatedBy=$USER_ID

# Get scripts and deployment assets
git clone $SOURCE_REPOSITORY

# Get directory
GIT=${SOURCE_REPOSITORY##*/}
DIR=${GIT%.*}

# Run scripts
sh $DIR$ENTRYPOINT