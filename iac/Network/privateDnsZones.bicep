
 @description('Name of the private-DNS-zone')
 param privateDnsZoneName string
 
 @description('Name of the VNET-link to create')
 param vnetLinkName string
 @description('Id of the VNET to link the VNET-link to')
 param virtualNetworkId string
 
 @description('Whether automatic registration of the virtual networklink is enabled')
 param autoregistrationEnabled bool = false
 
 resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
   name: privateDnsZoneName
   location: 'global'
 
   resource privateDnsZoneVirtualNetworkLink 'virtualNetworkLinks@2020-06-01' = {
     name: vnetLinkName
     location: 'global'
     properties: {
       registrationEnabled: autoregistrationEnabled
       virtualNetwork: {
         id: virtualNetworkId
       }
     }
   }
 }
  
  // return the Id of the private-DNS-zone
  output privateDnsZoneId string = privateDnsZone.id
  output privateDnsZonename string = privateDnsZone.name
 