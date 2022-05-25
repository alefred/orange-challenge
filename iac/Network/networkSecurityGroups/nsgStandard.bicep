param name string
param location string

// Create network security group (NSGs)
resource nsg 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: name 
  location: location
}

// return id 
output id string = nsg.id
