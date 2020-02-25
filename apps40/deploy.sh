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
tailwindInfrastructure=deployment.json
tailwindCharts=TailwindTraders-Backend/Deploy/helm
tailwindChartValuesScript=/helm-values/generate-config.ps1
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

# Clone Tailwind backend and checkout known stable tag
git clone https://github.com/microsoft/TailwindTraders-Backend.git
git -C TailwindTraders-Backend checkout ed86d5f

# Deploy network infrastructure
printf "\n*** Deploying networking resources ***\n"

# create the vnet
az network vnet create \
    --resource-group $azureResourceGroup \
    --name k8sVNet \
    --address-prefixes 10.0.0.0/8 \
    --subnet-name k8sSubnet \
    --subnet-prefix 10.240.0.0/16

# Create virtual node subnet
az network vnet subnet create \
    --resource-group $azureResourceGroup  \
    --vnet-name k8sVNet \
    --name VNSubnet  \
    --address-prefix 10.241.0.0/16


# Deploy backend infrastructure
printf "\n*** Deploying resources: this will take a few minutes... ***\n"
vnetID=$(az network vnet subnet show --resource-group $azureResourceGroup --vnet-name k8sVNet --name k8sSubnet --query id -o tsv)
az group deployment create -g $azureResourceGroup --template-file $tailwindInfrastructure \
  --parameters servicePrincipalId=$azureClientID servicePrincipalSecret=$azureClientSecret \
  sqlServerAdministratorLogin=$sqlServerUser sqlServerAdministratorLoginPassword=$sqlServePassword \
  aksVersion=1.15.7 pgversion=10 vnetSubnetID=$vnetID

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

printf "\n*** Installing virtual node on Kubernets cluster... ***\n"
# Deploy virtual node 
az aks enable-addons \
    --resource-group $azureResourceGroup  \
    --name $AKS_CLUSTER \
    --addons virtual-node \
    --subnet-name VNSubnet

# Create Kubernetes Service Account
printf "\n*** Create Helm service account in Kubernetes... ***\n"
nameSpace=twt
kubectl create namespace $nameSpace
kubectl label namespace/$nameSpace purpose=prod-app
#kubectl apply -f $tailwindServiceAccount

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
imagePullSecrets:
- name: acr-auth
metadata:
  name: ttsa
  namespace: $nameSpace
EOF


# Create Helm values file
printf "\n*** Create Helm values file... ***\n"

pwsh $tailwindChartValuesScript -resourceGroup $azureResourceGroup -sqlPwd $sqlServePassword -outputFile $tailwindChartValues

# Deploy application to Kubernetes
printf "\n***Deplpying applications to Kubernetes.***\n"

INGRESS=$(az aks show -n $AKS_CLUSTER -g $azureResourceGroup --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName -o tsv)
pictures=$(az storage account list -g $azureResourceGroup --query [0].primaryEndpoints.blob -o tsv)

# App Insights Versions
helm install --name my-tt-login -f $tailwindChartValues --namespace=$nameSpace --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/login.api --set image.tag=$containerVersion --set inf.storage.profileimages=${pictures}profiles-list $tailwindCharts/login-api
helm install --name my-tt-product -f $tailwindChartValues --namespace=$nameSpace --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/product.api --set image.tag=$containerVersion --set inf.storage.productimages=${pictures}product-list --set inf.storage.productdetailimages=${pictures}product-detail $tailwindCharts/products-api
helm install --name my-tt-coupon -f $tailwindChartValues --namespace=$nameSpace --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/coupon.api --set image.tag=$containerVersion --set inf.storage.couponimage=${pictures}coupon-list $tailwindCharts/coupons-api
helm install --name my-tt-profile -f $tailwindChartValues --namespace=$nameSpace --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/profile.api --set image.tag=$containerVersion --set inf.storage.profileimages=${pictures}profiles-list $tailwindCharts/profiles-api
helm install --name my-tt-popular-product -f $tailwindChartValues --namespace=$nameSpace --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/popular-product.api --set image.tag=$containerVersion --set initImage.repository=$containerRegistry/popular-product-seed.api --set initImage.tag=latest --set inf.storage.productimages=${pictures}product-list $tailwindCharts/popular-products-api
helm install --name my-tt-stock -f $tailwindChartValues --namespace=$nameSpace --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/stock.api --set image.tag=$containerVersion $tailwindCharts/stock-api
helm install --name my-tt-image-classifier -f $tailwindChartValues --namespace=$nameSpace --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/image-classifier.api --set image.tag=$containerVersion $tailwindCharts/image-classifier-api
helm install --name my-tt-cart -f $tailwindChartValues --namespace=$nameSpace --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/cart.api --set image.tag=$containerVersion $tailwindCharts/cart-api
helm install --name my-tt-mobilebff -f $tailwindChartValues --namespace=$nameSpace --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/mobileapigw --set image.tag=$containerVersion --set probes.readiness=null $tailwindCharts/mobilebff
helm install --name my-tt-webbff -f $tailwindChartValues --namespace=$nameSpace --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/webapigw --set image.tag=$containerVersion $tailwindCharts/webbff

# Pulling from a stable fork of the tailwind website
git clone https://github.com/neilpeterson/TailwindTraders-Website.git
helm install --name web -f TailwindTraders-Website/Deploy/helm/gvalues.yaml --namespace=$nameSpace --set ingress.protocol=http --set ingress.hosts={$INGRESS} --set image.repository=$containerRegistry/web --set image.tag=v1 TailwindTraders-Website/Deploy/helm/web/

# Label all pods in the twt namespce for the network policy to be applied
x=$(kubectl get pods -n twt -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{"\t"}{end}' |sort)
for i in $x
do
   kubectl label -n twt pods $i role=twt-app
done



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

#
printf "\n***Setting up sclaing backend componets.***\n"
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm install kedacore/keda --namespace keda --name keda
# This is to wait that keda has enrolled the external metrics api  
sleep 60
helm install --name rabbitmq --set rabbitmq.username=user,rabbitmq.password=PASSWORD stable/rabbitmq

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: rabbitmq-consumer
data:
  RabbitMqHost: YW1xcDovL3VzZXI6UEFTU1dPUkRAcmFiYml0bXEuZGVmYXVsdC5zdmMuY2x1c3Rlci5sb2NhbDo1Njcy
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rabbitmq-consumer
  namespace: default
  labels:
    app: rabbitmq-consumer
spec:
  selector:
    matchLabels:
      app: rabbitmq-consumer
  template:
    metadata:
      labels:
        app: rabbitmq-consumer
    spec:
      containers:
      - name: rabbitmq-consumer
        image: jeffhollan/rabbitmq-client:dev
        imagePullPolicy: Always
        command:
          - receive
        args:
          - 'amqp://user:PASSWORD@rabbitmq.default.svc.cluster.local:5672'
        envFrom:
        - secretRef:
            name: rabbitmq-consumer
      dnsPolicy: ClusterFirst
      nodeSelector:
        kubernetes.io/role: agent
        beta.kubernetes.io/os: linux
        type: virtual-kubelet
      tolerations:
      - key: virtual-kubelet.io/provider
        operator: Exists
      - key: azure.com/aci
        effect: NoSchedule      
---
apiVersion: keda.k8s.io/v1alpha1
kind: ScaledObject
metadata:
  name: rabbitmq-consumer
  namespace: default
  labels:
    deploymentName: rabbitmq-consumer
spec:
  scaleTargetRef:
    deploymentName: rabbitmq-consumer
  pollingInterval: 5   # Optional. Default: 30 seconds
  cooldownPeriod: 30   # Optional. Default: 300 seconds
  maxReplicaCount: 30  # Optional. Default: 100
  triggers:
  - type: rabbitmq
    metadata:
      queueName: hello
      host: RabbitMqHost
      queueLength  : '5'
EOF
  
  
  
# Notes
echo "*************** Connection Information ***************"
echo "The Tailwind Traders Website can be accessed at:"
echo "http://$INGRESS"
echo ""
echo "Run the following to connect to the AKS cluster:"
echo "az aks get-credentials --name $AKS_CLUSTER --resource-group $azureResourceGroup --admin"
echo "******************************************************"
