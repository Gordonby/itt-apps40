RESOURCEGROUP=MyTailwind
LOC=eastus
SPNAME=Tailwind555

#Self Hosted Runner Azure VM
VMNAME=co01git01
VMRESOURCEGROUP=contosodomain

echo "Getting subscription Id"
SUBSCRIPTION=$(az account show --query 'id' -o tsv)
SUBSCRIPTIONNAME=$(az account show --query 'name' -o tsv)

echo "Creating resource group"
az group create -n $RESOURCEGROUP -l $LOC

echo "Creating Service Principal"
SP=$(az ad sp create-for-rbac --name "http://$SPNAME" --role owner --scopes /subscriptions/$SUBSCRIPTION/resourceGroups/$RESOURCEGROUP --sdk-auth)
echo ""
echo $SP
echo ""
echo "Copy this JSON into your AZURE_CREDENTIALS secret"

CLIENTID=$(echo $SP | jq -r '.clientId')

echo "Giving Service Principal access to GitHub runner"
az role assignment create --assignee $CLIENTID --role "Virtual Machine Contributor" --scope /subscriptions/$SUBSCRIPTION/resourceGroups/$VMRESOURCEGROUP/providers/Microsoft.Compute/virtualMachines/$VMNAME


echo "Adding AKS Service Principal"
AKSSP=$(az ad sp create-for-rbac --skip-assignment --name "${RESOURCEGROUP}akssp")
AKSCLIENTID=$(echo $SP | jq -r '.clientId')
AKSSECRET=$(echo $SP | jq -r '.clientSecret')
az role assignment create --assignee $AKSCLIENTID --scope /subscriptions/$SUBSCRIPTION/resourceGroups/$RESOURCEGROUP --role Contributor
echo $AKSSP

echo "Secret values for your GitHub repo"
echo "Azure Credentials"
echo $SP | jq '.'
echo ""
echo "AKS CLIENT ID: $AKSCLIENTID"
echo "AKS CLIENT SECRET: $AKSSECRET"

echo ""
echo "Launch your Github Action with these values"
echo "Resource Group = $RESOURCEGROUP"
echo "Location = $LOC"
echo "Azure subscription name = $SUBSCRIPTIONNAME"
