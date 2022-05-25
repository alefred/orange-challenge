param environmentShort string
param location string
param locationShort string
param logAnalyticsWorkspaceId string
param paasSubnetId string

// Container Registry
param acrPrivateDnsZoneName string
param acrPrivateDnsZoneId string
var acrName = 'acr${environmentShort}${locationShort}001'
module containerRegistry 'ContainerRegistry/registries.bicep' = {
  name: 'containerRegistry-data'
  params: {
    name:acrName
    location: location
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    privateDnsZoneId: acrPrivateDnsZoneId
    privateDnsZoneName: acrPrivateDnsZoneName
    subnetId: paasSubnetId
  }
}

output acrName string = acrName


// Web app and Hosting plan
module webapp 'Web/sites.bicep' = {
  name: 'webappm'
  params: {
    location: location
    siteName: 'orangeApp'
  }
}

