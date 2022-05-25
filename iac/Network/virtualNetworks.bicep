@description('Specifies the location for resources.')
param location string

@description('Name of the VNET')
param name string

@description('Address space of the VNET')
param vnetAddressSpace string

@description('Subnet specifications')
param subnets array

@description('Id of the Log Analytics workspace to send logs and metrics too')
param logAnalyticsWorkspaceId string

// Create VNET including subnets
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressSpace
      ]
    }
    subnets: [for (subnet, i) in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.addressSpace
        serviceEndpoints: subnet.serviceEndpoints
        networkSecurityGroup: {
          id: subnet.nsgId
        }
        privateEndpointNetworkPolicies: subnet.privateEndpointNetworkPolicies
        privateLinkServiceNetworkPolicies: subnet.privateLinkServiceNetworkPolicies
        delegations: subnet.delegations
      }
    }]
  }
}

// return the Id of the VNET
output vnetId string = virtualNetwork.id

// return the Ids of the subnets
output subnetIds array = [for i in range(0, length(subnets)): virtualNetwork.properties.subnets[i].id]


// Diagnostic Settings
resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: virtualNetwork
  name: 'diag-${virtualNetwork.name}'
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
