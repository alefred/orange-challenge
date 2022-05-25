param environmentShort string
param location string
param locationShort string
param logAnalyticsWorkspaceId string

// Namig Section
var virtualNetworkName = 'vnet-${environmentShort}-${locationShort}-001'
var paasSubnetName = 'snet-paas-${locationShort}-001'
var defaultSubnetName = 'snet-default-${locationShort}-001'
// Close naming section

//NSGs
module nsgStandard 'Network/networkSecurityGroups/nsgStandard.bicep' = {
  name: 'nsgStandard'
  params: {
    location: location
    name: 'nsg-standard-${environmentShort}-${locationShort}-001'
  }
}

// Virtual Networks
module vnet 'Network/virtualNetworks.bicep' = {
  name: 'virtualNetwork'
  params: {
    name: virtualNetworkName 
    location: location
    vnetAddressSpace: '10.0.0.0/16'
    subnets: [
      {
        name: defaultSubnetName
        addressSpace: '10.0.0.0/24'
        serviceEndpoints: []
        delegations: []
        privateLinkServiceNetworkPolicies: 'Enabled'
        privateEndpointNetworkPolicies: 'Enabled'
        nsgId: nsgStandard.outputs.id
      }
      {
        name: paasSubnetName
        addressSpace: '10.0.3.0/24'
        serviceEndpoints: []
        delegations: []
        privateLinkServiceNetworkPolicies: 'Disabled'
        privateEndpointNetworkPolicies: 'Disabled'
        nsgId: nsgStandard.outputs.id
      }
   ]
   logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
  }
}

output vnetId string = vnet.outputs.vnetId
output paasSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, paasSubnetName)
output subnetDefaultId string = resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, defaultSubnetName)

output vnetName string = virtualNetworkName

// Private DNS ZONES
//Dns Private Zone for Keyvault
module privateDnsVault 'Network/privateDnsZones.bicep'= {
  name: 'privatednsvault'
  params: {
    privateDnsZoneName: 'privatelink.vaultcore.azure.net'
    virtualNetworkId: vnet.outputs.vnetId
    vnetLinkName: 'link-${vnet.name}'
  }
}

output keyVaultPrivateDNSZoneName string = privateDnsVault.outputs.privateDnsZonename
output keyVaultPrivateDNSZoneId string = privateDnsVault.outputs.privateDnsZoneId

//Dns Private Zone for Storage Account
module privateDnsStg 'Network/privateDnsZones.bicep'= {
  name: 'privatednsstg'
  params: {
    privateDnsZoneName: 'privatelink.blob.${environment().suffixes.storage}'
    virtualNetworkId: vnet.outputs.vnetId
    vnetLinkName: 'link-${vnet.name}'
  }
}

output storagePrivateDNSZoneName string = privateDnsStg.outputs.privateDnsZonename
output storagePrivateDNSZoneId string = privateDnsStg.outputs.privateDnsZoneId

//Dns Private Zone for ACR
module privateDnsAcr 'Network/privateDnsZones.bicep'= {
  name: 'privatednsacr'
  params: {
    privateDnsZoneName: 'privatelink${environment().suffixes.acrLoginServer}' //privatelink.azurecr.io
    virtualNetworkId: vnet.outputs.vnetId
    vnetLinkName: 'link-${vnet.name}'
  }
}

output acrPrivateDNSZoneName string = privateDnsAcr.outputs.privateDnsZonename
output acrPrivateDNSZoneId string = privateDnsAcr.outputs.privateDnsZoneId
