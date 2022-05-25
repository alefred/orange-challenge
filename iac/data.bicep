param environmentShort string
param location string
param locationShort string
param logAnalyticsWorkspaceId string
param paasSubnetId string

// Storage account
param stgPrivateDnsZoneName string
param stgPrivateDnsZoneId string
module storageAccount 'Storage/storageAccounts.bicep' = {
  name: 'storageAccount-data'
  params: {
    location: location
    name: 'stg${environmentShort}${locationShort}001'
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
    privateDnsZoneId: stgPrivateDnsZoneId
    privateDnsZoneName: stgPrivateDnsZoneName
    subnetId: paasSubnetId
  }
}


