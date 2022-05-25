param name string
param location string
param logAnalyticsWorkspaceId string

param StorageSkuName string = 'Standard_LRS'
param isStorageAccountAdls bool = false
param subnetId string
param privateDnsZoneName string
param privateDnsZoneId string

// Storage Account resource creation
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: name
  location: location
  properties: {
    allowCrossTenantReplication: false
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  isHnsEnabled: isStorageAccountAdls
    networkAcls: {
      virtualNetworkRules: []
      defaultAction: 'Deny'
    }
  }
  kind: 'StorageV2'
  sku: {
    name: StorageSkuName
  }
}

resource storageAccountATP 'Microsoft.Security/advancedThreatProtectionSettings@2019-01-01' = {
  name: 'current'
  scope: storageAccount
  properties: {
    isEnabled: true
  }
}


// Set Private Endpoint for storage account
module privateEndpointStorageModule '../Network/privateEndpoints.bicep' = {
  name: 'privateEndpointStorageDeploy'
  params: {
    location: location
    privateEndpointName: 'pe-${name}'
    virtualNetworkSubnetId: subnetId
    privateLinkServiceId: storageAccount.id
    privateDnsZoneId: privateDnsZoneId
    privateDnsZoneName: privateDnsZoneName
    configureManualConnection: false
    privateLinkConnectionGroupIds:[
      'blob'
    ]
  }
}

// Diagnostic Settings
resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: storageAccount
  name: 'diag-${storageAccount.name}'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    metrics: [
      {
        category: 'Transaction'
        enabled: true
      }
    ]
  }
}


//Output Section
output storageAccountId string = storageAccount.id
