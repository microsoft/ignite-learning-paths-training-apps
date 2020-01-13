#!/bin/bash

# example command:
# sh scripts/get-secrets.sh

set -e

# Set the following
spName=tailwindtraders30
adminUser=twtadmin
adminPassword=twtapps30pD
subName="Ignite The Tour"
location=eastus

# set the subscription
az account set --subscription "$subName" && echo "Your default subscription has been set to: $subName"

# Create a service principal
    echo "Creating service principal..."
    spInfo=$(az ad sp create-for-rbac --name "$spName" \
            --role contributor \
            --sdk-auth)

    if [ $? == 0 ]; then
        echo '========================================================='
        echo 'GitHub secrets for configuring GitHub INFRA workflow'
        echo '========================================================='
        echo "AZURE_CREDENTIALS: $spInfo"
        echo "SQL_ADMIN: $adminUser"
        echo "SQL_PASSWORD: $adminPassword"
        echo '========================================================='
        echo ''
    else
        "An error occurred. Please try again."
         exit 1
    fi
