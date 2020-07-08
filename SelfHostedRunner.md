# Self Hosted Runner
Because of the way that the GitHub action is structured using 3 steps, and the need for files and variables to be passed between them.  
At the moment it's easiest just to leverage a self hosted runner for GitHub Actions, it might be worth refactoring the Action at some point but after starting - the value for effort was low.

## VM Setup
Create a VM  (i went for Ubuntu 18.x VM in Azure)

### Install the AZ CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

### Install Powershell
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo add-apt-repository universe
sudo apt-get install -y powershell

### Install Kubectl
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

### Install Helm
curl https://helm.baltorepo.com/organization/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

### Install Docker
sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io

sudo apt install docker.io

#### Docker permissions
Add the user to the Docker group, otherwise you'll get an error like this "Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock"

sudo usermod -a -G docker $USER

### Install GitHub Runner
In GitHib, in Settings and Actions;
Add a self hosted runner, following the github script commands to register the runner

