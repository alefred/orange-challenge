 @description('Location for all resources')
 param location string = resourceGroup().location
 
 @description('Name of the PrivateEndpoint to be created')
 param privateEndpointName string
 
 @description('Id of the subnet in the VNET to attach the PrivateEndpoint to')
 param virtualNetworkSubnetId string
 
 @description('Resource Id of the service to link the PrivateEndpoint to')
 param privateLinkServiceId string
 @description('GroupIds to be configured at the PrivateLink connection')
 param privateLinkConnectionGroupIds array = []
 
 @description('Name of the private-DNS-zone')
 param privateDnsZoneName string
 
 @description('Id of the private-DNS-zone')
 param privateDnsZoneId string
 
 @description('Whether or not to create a manual or automatic connection')
 param configureManualConnection bool = false
 
 // Create PrivateEndpoint service
 resource privateEndpointResource 'Microsoft.Network/privateEndpoints@2020-11-01' = {
   name: privateEndpointName
   location: location
   properties: {
     manualPrivateLinkServiceConnections: configureManualConnection ? [
       {
         name: privateEndpointName
         properties: {
           privateLinkServiceId: privateLinkServiceId
           groupIds: privateLinkConnectionGroupIds
           requestMessage: 'IaC provisioned'
         }
       }
     ] : []
     privateLinkServiceConnections: configureManualConnection == false ? [
       {
         name: privateEndpointName
         properties: {
           privateLinkServiceId: privateLinkServiceId
           groupIds: privateLinkConnectionGroupIds
           requestMessage: 'IaC provisioned'
         }
       }
     ] : []
     subnet: {
       id: virtualNetworkSubnetId
     }
     customDnsConfigs: []
   }
 }
 
 // Create PrivateEndpointDnsZoneGroup service
 resource privateEndpointDsnZoneGroupResource 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-07-01' = {
   name: '${privateEndpointName}/default'
   properties: {
     privateDnsZoneConfigs: [
       {
         name: privateDnsZoneName
         properties: {
           privateDnsZoneId: privateDnsZoneId
         }
       }
     ]
   }
   dependsOn: [
     privateEndpointResource
   ]
 }
 
 output NicId string = privateEndpointResource.properties.networkInterfaces[0].id
 