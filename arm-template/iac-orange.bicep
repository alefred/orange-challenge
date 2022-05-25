@minLength(3)
@maxLength(24)
param webAppName string

var servicePlanName_var = '${webAppName}-ServicePlan'
var acrName_var = '${webAppName}Acr'
var acrId = acrName.id
var acrUrl = 'https://${acrName_var}.azurecr.io'
var insightName_var = '${webAppName}Insight'
var insightId = insightName.id
var errorPage = 'https://${webAppName}.scm.azurewebsites.net/detectors?type=tools&name=eventviewer'

resource acrName 'Microsoft.ContainerRegistry/registries@2020-11-01-preview' = {
  name: acrName_var
  location: 'East US 2'
  tags: {
    reason: 'orange-challenge'
  }
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  properties: {
    adminUserEnabled: true
    dataEndpointEnabled: false
    publicNetworkAccess: 'Enabled'
    networkRuleBypassOptions: 'AzureServices'
    zoneRedundancy: 'Disabled'
    anonymousPullEnabled: false
  }
}

resource servicePlanName 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: servicePlanName_var
  location: resourceGroup().location
  tags: {
    reason: 'orange-challenge'
  }
  sku: {
    tier: 'Basic'
    name: 'B3'
  }
  kind: 'linux'
  properties: {
    name: servicePlanName_var
    numberOfWorkers: 1
    reserved: true
  }
}

resource webAppName_resource 'Microsoft.Web/sites@2018-11-01' = {
  name: webAppName
  location: resourceGroup().location
  tags: {
    reason: 'orange-challenge'
  }
  properties: {
    serverFarmId: servicePlanName.id
    siteConfig: {
      name: webAppName
      appSettings: [
        {
          name: 'PORT'
          value: '8080'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: acrUrl
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: acrName_var
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: listCredentials(acrId, '2020-11-01-preview').passwords[0].value
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: reference(insightId, '2015-05-01').InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: reference(insightId, '2015-05-01').ConnectionString
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~2'
        }
        {
          name: 'XDT_MicrosoftApplicationInsights_Mode'
          value: 'default'
        }
        {
          name: 'ANCM_ADDITIONAL_ERROR_PAGE_LINK'
          value: errorPage
        }
      ]
    }
  }
  dependsOn: [
    acrId
    insightId
  ]
}

resource insightName 'microsoft.insights/components@2015-05-01' = {
  name: insightName_var
  location: 'East US 2'
  kind: 'web'
  tags: {
    reason: 'orange-challenge'
  }
  properties: {
    Application_Type: 'web'
    ApplicationId: webAppName
  }
}