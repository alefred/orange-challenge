<p align="center">
  <a href="" rel="noopener">
 <img src="https://chi01pap002files.storage.live.com/y4mlaO_NDkgJ4uxGWNTZaW5ETLc5egUpq-WPXvWwbqmVp3wrUe2o8KDQbn2eVnVBrGf7rHj4tLiaSs9IyZ9iFJh_U552wj5Jjtn8Pv60fOY9YxBZn1ObOKl_k4kxDKMnwfCFX41Kvxg9tlKshftLPbiJAdMyUH-B0UP24gfy2BL7kgSFXOOwLdMAeoCwDZ13aLS?width=2204&height=1326&cropmode=none" alt="Project logo"></a>
</p>
<h3 align="center">Cloud Assignment</h3>
<h4 align="center">codename: orange-challenge</h4>
</br>
<div align="center">

[![codename](https://img.shields.io/badge/codename-orange-orange.svg)](https://github.com/alefred/orange-challenge)
[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE.md)

</div>

---

<p align="center"> Few lines describing your project.
    <br> 
</p>

## 📝 Table of Contents

- [📝 Table of Contents](#-table-of-contents)
- [🧐 Requirements <a name = "Requirements"></a>](#-requirements-)
- [⛏️ Solution <a name = "idea"></a>](#️-solution-)
- [⛓️ Dependencies / Limitations <a name = "limitations"></a>](#️-dependencies--limitations-)
- [🚀 Future Scope <a name = "future_scope"></a>](#-future-scope-)
- [🏁 How to use <a name = "getting_started"></a>](#-how-to-use-)
  - [Fork the project](#fork-the-project)
  - [Prepare connection with Azure](#prepare-connection-with-azure)
  - [CI/CD](#cicd)
  - [Clean Up Infrastructure](#clean-up-infrastructure)
- [🎉 Deliverables <a name = "acknowledgments"></a>](#-deliverables-)

## 🧐 Requirements <a name = "Requirements"></a>

The main objective of this project is achive the below requirements:
- As a DevOps engineer, I want to have a CI/CD pipeline for my application
The pipeline must build and test the application code base.
The pipeline must build and push a Docker container ready to use.
The pipeline must deploy the application across different environments on the target
infrastructure.
  - Bonus point: Separate the backend and the frontend in different pipelines and containers.
- As a DevOps engineer, I want to have a pipeline to deploy the required infrastructure for my application
The infrastructure must be created on the cloud, for the purpose of the assignment any
public cloud can be used.
The deployment pipeline must use infrastructure as code (Cloud Formation, Cloud
Deployment Manager, Azure Resource Manager or Terraform).
The delivered infrastructure must be monitored and audited.
The delivered infrastructure must allow multiple personal accounts.
For the purpose of the assignment, you will define the cloud architecture that you see fit, document it and explain the resources created and choices made.
  - Bonus point: The delivered infrastructure must be able to scale automatically.
  - Bonus point: Modify the application to make use of real database running on the cloud,
instead of the in-memory database.TIP: We'd highly appreciate if you provide cleanup/destroy functionality as part of the
pipeline

## ⛏️ Solution <a name = "idea"></a>

  The technologies and tools selecteds to achieve the requeriment are:

  - Cloud Provider: Azure
  - CI/CD tool: Git Hub Action
  - Container Registry: Azure container Registry
  - Container : Azure WebApp for containers
  - Monitoring Tool:  Azure App Insight
  - Infrastructure as code : Azure ARM templates

The application has been deployed in Azure, the pipeline process is explaining below:

 1. First create the resource group whom will store the resources deployed
 2. After that create a service principal a give the permission only over the resource group created
 3. Deploy the resources with the arm template 
   
    - Azure container Registry
    - Azure WebApp for containers
    - Azure Service plan
    - Azure App Insight
 4. Build a docker image and upload to Azure container registry
 5. Deploy the container image to the webapp 
 6. Test access to the web application deployed with a python script and chrome driver (Selenium)

## ⛓️ Dependencies / Limitations <a name = "limitations"></a>

This version v1 have a below limitations:

- Static Application's Name beetween different environments
- Start the deployment infrastructure require execute command in azure CLI 
- The unit-test enviroment is setted just in a Linux environment
- ⛏️ **It's necessary cleanup the insfrastructure before deploy in different environment (Azure Subscription)**

## 🚀 Future Scope <a name = "future_scope"></a>

Next version must have:

 - Autoscaling the web app 
 - Use SQL Azure Database
 - Separate the backend and the frontend in different pipelines and containers

## 🏁 How to use <a name = "getting_started"></a>

These instructions will get you a copy of the project up and running on your local machine for development
and testing purposes. See [deployment](#deployment) for notes on how to deploy the project on a live system.

### Fork the project
 1. On GitHub, navigate to the octocat/Spoon-Knife repository.
 2. In the top-right corner of the page, click Fork.
   ![picture alt](https://docs.github.com/assets/images/help/repository/fork_button.jpg "Title is optional")
Fork button

### Prepare connection with Azure
Connect to az cli with:
```
az login --use-device-code
```
Execute next command in your az cli in order to copy the output:
```
$appSpName="oczoom-spApp"
$rgName="oczoom_rg"
$subscriptionId = az account show --query id --output tsv
az group create --resource-group $rgName --location "East US 2"
az ad sp create-for-rbac --name $appSpName --role contributor --scopes "/subscriptions/$subscriptionId/resourceGroups/$rgName" --sdk-auth

```
The output could be similar to:
```
{
  "clientId": "-------------------------e8",
  "clientSecret": "Y93m-------------------------W",
  "subscriptionId": "f3c-------------------------8",
  "tenantId": "0c6-------------------------",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}

```
Copy the output and paste as a new secret "AZURE_CREDENTIALS" in github repo forked as the image show:
![picture alt](https://chi01pap002files.storage.live.com/y4mlQu23SCpALUKVmBx1UmaMagS-gWh9Rgq-zxySMOYexJ3XKcoJrF2c6MZ0JS2kDoWJZLoQe1Q3coI_GWBVBp9JrTpQBA3ELlAzqhmJHjbqPi_F4w2RD2iL2ISpm2KGtO0oskDImOb1KeZ3zcDpdvWMKcBW4X7uDBqHUt0x5fEvwpv_LtceI7eEi7YkSxQK0Zs?width=1352&height=739&cropmode=none "Title is optional")

### CI/CD
Push a change to the main branch and go to GitHub Action to see the process
![picture alt](https://chi01pap002files.storage.live.com/y4mSCH-CpKWJ20RifjiSwuCfmrSMGRZObG7gs33Fn4FxmAknlR_zkpnReaAUbFWfxeSbJrSd-sWEIyzOjc4LwLs3VIRXLEFo8PpofCceWtWGCzrfIR9Z4LmNeYkIPOHqSW44c8Hk0gZlV0WAWiJ5nxRoPeXQwK03FY-TGh25G3i4jaSEHvbU4RZaKdeSDFoR9wc?width=1909&height=755&cropmode=none "Title is optional")

Browse the app: [oczoom.azurewebsites.net](http://oczoom.azurewebsites.net/login)

### Clean Up Infrastructure

Execute the next list of commands in Azure Cli

```
$appSpName="oczoom-spApp"
$rgName="oczoom_rg"
$subscriptionId = az account show --query id --output tsv
az group delete --resource-group $rgName --yes
az ad sp delete --id (az ad sp list --display-name $appSpName --query "[].appId" --output tsv)
```


## 🎉 Deliverables <a name = "acknowledgments"></a>

- Source code of the pipeline(s) and the IaC source code of the solution implemented:

  - Pipeline(s) code: .github\workflow\cicd-orange.yml
  - Iac code: arm-template\iac-orange.json
- Instructions on how to fork, configure and deploy the solution on our own cloud
environment
  - https://github.com/alefred/orange-challenge
  
    - [🏁 How to use <a name = "getting_started"></a>](#-how-to-use-)
- High-level documentation explaining the overall architecture of the solution implemented.
  - https://github.com/alefred/orange-challenge
    - [⛏️ Solution <a name = "idea"></a>](#️-solution-)



*Url app after deploy: oczoom.azurewebsites.net*
  
