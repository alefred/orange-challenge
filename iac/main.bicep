targetScope = 'subscription'
@allowed([
  'dev'
  'tst'
  'prd'
])
param environmentShort string
param location string = 'centralindia'
param locationShort string = 'ci'

// Namig Section
var logAnalyticsWorkspaceName = 'law-${environmentShort}-${locationShort}-001'
// Close naming section

resource rgOrange 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-orange-${environmentShort}-${locationShort}-001'
  location: location
}

module logAnalytics 'OperationalInsights/workspaces.bicep' = {
  name: 'logAnalyticsworkspace-main'
  scope: rgOrange
  params: {
    name: logAnalyticsWorkspaceName
    location: location
  }
}

module infrastructure 'infrastructure.bicep' = {
  scope: rgOrange
  name: 'infrastructure-main'
  params: {
    environmentShort: environmentShort
    location: location
    locationShort: locationShort
    logAnalyticsWorkspaceId: logAnalytics.outputs.id
  }
}

module data 'data.bicep' = {
  scope: rgOrange
  name: 'data-main'
  params: {
    environmentShort: environmentShort
    location: location
    locationShort: locationShort
    logAnalyticsWorkspaceId: logAnalytics.outputs.id
    stgPrivateDnsZoneId:infrastructure.outputs.storagePrivateDNSZoneId
    stgPrivateDnsZoneName:infrastructure.outputs.storagePrivateDNSZoneName
    paasSubnetId:infrastructure.outputs.paasSubnetId
  }
}

module application 'application.bicep' = {
  scope: rgOrange
  name: 'application'
  params: {
    environmentShort: environmentShort
    location: location
    locationShort: locationShort
    acrPrivateDnsZoneId: infrastructure.outputs.acrPrivateDNSZoneId
    acrPrivateDnsZoneName: infrastructure.outputs.acrPrivateDNSZoneName
    logAnalyticsWorkspaceId: logAnalytics.outputs.id
    paasSubnetId:infrastructure.outputs.paasSubnetId
  }
}
