#!/bin/bash
set -e

# Credentials
azureClientID=$CLIENT_ID
azureClientSecret=$SECRET
sqlServerUser=sqladmin
sqlServePassword=Password2020!

# Azure and container image location
azureResourceGroup=$RESOURCE_GROUP_NAME
containerRegistry=neilpeterson
containerVersion=v2

# Tailwind deployment
tailwindInfrastructure=TailwindTraders-Backend/Deploy/deployment.json
tailwindCharts=TailwindTraders-Backend/Deploy/helm
tailwindChartValuesScript=tailwind-reference-deployment-sandbox/deployment-artifacts-aks/helm-values/generate-config.ps1
tailwindChartValues=/values.yaml
tailwindWebImages=TailwindTraders-Backend/Deploy/tt-images
tailwindServiceAccount=TailwindTraders-Backend/Deploy/helm/ttsa.yaml

# Print out tail command
printf "\n*** To tail logs, run this command... ***\n"
echo "*************** Container logs ***************"
echo "az container logs --name bootstrap-container --resource-group $azureResourceGroup --follow"
echo "*************** Connection Information ***************"

# Get backend code
printf "\n*** Cloning Tailwind code repository... ***\n"

# git clone https://github.com/microsoft/TailwindTraders-Backend.git
git clone https://github.com/nepeters007/TailwindTraders-Backend.git

# Deploy backend infrastructure
printf "\n*** Deploying resources: this will take a few minutes... ***\n"

az group deployment create -g $azureResourceGroup --template-file $tailwindInfrastructure \
  --parameters servicePrincipalId=$azureClientID servicePrincipalSecret=$azureClientSecret \
  sqlServerAdministratorLogin=$sqlServerUser sqlServerAdministratorLoginPassword=$sqlServePassword \
  aksVersion=1.14.5 pgversion=10

# # Application Insights (using preview extension)
az extension add -n application-insights
instrumentationKey=$(az monitor app-insights component show --app tt-app-insights --resource-group $azureResourceGroup --query instrumentationKey -o tsv)

# Create postgres DB, Disable SSL, and set Firewall
printf "\n*** Create stockdb Postgres database... ***\n"

POSTGRES=$(az postgres server list --resource-group $azureResourceGroup --query [0].name -o tsv)
az postgres db create -g $azureResourceGroup -s $POSTGRES -n stockdb
az postgres server update --resource-group $azureResourceGroup --name $POSTGRES --ssl-enforcement Disabled
az postgres server firewall-rule create --resource-group $azureResourceGroup --server-name $POSTGRES --name AllowAllAzureIps --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0

# Install Helm on Kubernetes cluster
printf "\n*** Installing Tiller on Kubernets cluster... ***\n"

AKS_CLUSTER=$(az aks list --resource-group $azureResourceGroup --query [0].name -o tsv)
az aks get-credentials --name $AKS_CLUSTER --resource-group $azureResourceGroup --admin
kubectl apply -f https://raw.githubusercontent.com/Azure/helm-charts/master/docs/prerequisities/helm-rbac-config.yaml
helm init --wait --service-account tiller

# Create Kubernetes Service Account
printf "\n*** Create Helm service account in Kubernetes... ***\n"

kubectl apply -f $tailwindServiceAccount

# Create Helm values file
printf "\n*** Create Helm values file... ***\n"

pwsh $tailwindChartValuesScript -resourceGroup $azureResourceGroup -sqlPwd $sqlServePassword -outputFile $tailwindChartValues

# Deploy application to Kubernetes
printf "\n***Deplpying applications to Kubernetes.***\n"

INGRESS=$(az aks show -n $AKS_CLUSTER -g $azureResourceGroup --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName -o tsv)
pictures=$(az storage account list -g $azureResourceGroup --query [0].primaryEndpoints.blob -o tsv)

# App Insights Versions
helm install --name my-tt-login -f $tailwindChartValues --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/login.api --set image.tag=$containerVersion --set inf.storage.profileimages=${pictures}profiles-list $tailwindCharts/login-api
helm install --name my-tt-product -f $tailwindChartValues --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/product.api --set image.tag=$containerVersion --set inf.storage.productimages=${pictures}product-list --set inf.storage.productdetailimages=${pictures}product-detail $tailwindCharts/products-api
helm install --name my-tt-coupon -f $tailwindChartValues --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/coupon.api --set image.tag=$containerVersion --set inf.storage.couponimage=${pictures}coupon-list $tailwindCharts/coupons-api
helm install --name my-tt-profile -f $tailwindChartValues --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/profile.api --set image.tag=$containerVersion --set inf.storage.profileimages=${pictures}profiles-list $tailwindCharts/profiles-api
helm install --name my-tt-popular-product -f $tailwindChartValues --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/popular-product.api --set image.tag=$containerVersion --set initImage.repository=$containerRegistry/popular-product-seed.api --set initImage.tag=latest --set inf.storage.productimages=${pictures}product-list $tailwindCharts/popular-products-api
helm install --name my-tt-stock -f $tailwindChartValues --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/stock.api --set image.tag=$containerVersion $tailwindCharts/stock-api
helm install --name my-tt-image-classifier -f $tailwindChartValues --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/image-classifier.api --set image.tag=$containerVersion $tailwindCharts/image-classifier-api
helm install --name my-tt-cart -f $tailwindChartValues --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/cart.api --set image.tag=$containerVersion $tailwindCharts/cart-api
helm install --name my-tt-mobilebff -f $tailwindChartValues --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/mobileapigw --set image.tag=$containerVersion --set probes.readiness=null $tailwindCharts/mobilebff
helm install --name my-tt-webbff -f $tailwindChartValues --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/webapigw --set image.tag=$containerVersion $tailwindCharts/webbff

# Issue to fix with upstream: https://github.com/microsoft/TailwindTraders-Website/commit/0ab7e92f437c45fd6ac5c7c489e88977fd1f6ebc
git clone https://github.com/neilpeterson/TailwindTraders-Website.git
helm install --name web -f TailwindTraders-Website/Deploy/helm/gvalues.yaml --set ingress.protocol=http --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/web --set image.tag=v1 TailwindTraders-Website/Deploy/helm/web/

# Copy website images to storage
printf "\n***Copying application images (graphics) to Azure storage.***\n"

STORAGE=$(az storage account list -g $azureResourceGroup -o table --query  [].name -o tsv)
BLOB_ENDPOINT=$(az storage account list -g $azureResourceGroup --query [].primaryEndpoints.blob -o tsv)
CONNECTION_STRING=$(az storage account show-connection-string -n $STORAGE -g $azureResourceGroup -o tsv)
az storage container create --name "coupon-list" --public-access blob --connection-string $CONNECTION_STRING
az storage container create --name "product-detail" --public-access blob --connection-string $CONNECTION_STRING
az storage container create --name "product-list" --public-access blob --connection-string $CONNECTION_STRING
az storage container create --name "profiles-list" --public-access blob --connection-string $CONNECTION_STRING
az storage blob upload-batch --destination $BLOB_ENDPOINT --destination coupon-list  --source $tailwindWebImages/coupon-list --account-name $STORAGE
az storage blob upload-batch --destination $BLOB_ENDPOINT --destination product-detail --source $tailwindWebImages/product-detail --account-name $STORAGE
az storage blob upload-batch --destination $BLOB_ENDPOINT --destination product-list --source $tailwindWebImages/product-list --account-name $STORAGE
az storage blob upload-batch --destination $BLOB_ENDPOINT --destination profiles-list --source $tailwindWebImages/profiles-list --account-name $STORAGE

# Notes
echo "*************** Connection Information ***************"
echo "The Tailwind Traders Website can be accessed at:"
echo "http://$INGRESS"
echo ""
echo "Run the following to connect to the AKS cluster:"
echo "az aks get-credentials --name $AKS_CLUSTER --resource-group $azureResourceGroup --admin"
echo "******************************************************"