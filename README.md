# Tailwind bootstrap

## Repo history
Cloned from Jessica's repo (Microsoft Cloud Developer Advocate).  Her repo's intended to prime lots of content for a "train the trainer" session.
https://github.com/jldeen/itt-apps40

## Purpose of this repo
Purely and simply to get started with the Tailwind Traders application.  It's been an absolute ache to get it running seamlessly, and using a GitHub action seems to be the best way.

## Steps to deployment
There's a GitHub action that runs and does everything!

Ok, well not quite everything.  But ALMOST everything.  GitHub actions generally depend on some secrets which store things like credentials so they can actually run in your environment.  To speed that up, i've even made a short script you can run in the Azure CloudShell

1. Fork this repo.
1. Create a Self hosted Runner if you don't already have one. https://github.com/Gordonby/itt-apps40/blob/master/SelfHostedRunner.md
1. Run the setup script in https://shell.azure.com
   This will give you 4 secrets that you need to plug into your repo's secret store.  One of those secrets is called Azure Credentials, it's a new Service Principal that will be used by GitHub to access your Azure subscription.
   The script will also create a resource group and assign the new Service Principal permission to do stuff.  
   https://raw.githubusercontent.com/Gordonby/itt-apps40/master/Azure-Prerequisite-Setup.sh
1. Add the secrets from above into the repo secrets
1. Run the GitHub action
1. Wait, like a long time
1. Run kubectl against AKS and marvel at what's created.

## Troubleshooting

1. I've seen it where the pods can't come up because they're unauthorised on the ACR.  Best thing to do here is to run this, and authorise AKS against the ACR
```
acrName=$(az acr list -g $resourceGroup -o tsv --query [0].name)
az aks update -n $AKS_CLUSTER  -g $resourceGroup --attach-acr $acrName
```
