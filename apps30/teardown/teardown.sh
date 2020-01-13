#!/bin/bash
set -e

# variables
resourceGroup=igniteapps30
subName="Ignite The Tour"

# set subscription for script to run against
az account set --subscription "$subName" && echo "Your default subscription has been set to: $subName"

# delete everything
az group delete --subscription "$subName" --name $resourceGroup -y
