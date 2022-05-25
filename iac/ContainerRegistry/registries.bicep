param location string
param logAnalyticsWorkspaceId string
param subnetId string
param privateDnsZoneName string
param privateDnsZoneId string
param name string

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2021-09-01' = {
  name: name
  location: location
  sku: {
    name: 'Premium'
  }
}

module privateEndpoint_resource '../Network/privateEndpoints.bicep' = {
  name: 'private-Endpoint'
  params: {
    location: location
    privateEndpointName: 'pe-${name}'
    virtualNetworkSubnetId: subnetId
    privateLinkServiceId: containerRegistry.id
    privateDnsZoneName: privateDnsZoneName
    privateDnsZoneId: privateDnsZoneId
    privateLinkConnectionGroupIds: [
      'registry'
    ]
  }
}

// Diagnostic Settings
resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: containerRegistry
  name: 'diag-${containerRegistry.name}'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          days: 90
          enabled: true
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

output name string = containerRegistry.name
output id string = containerRegistry.id
