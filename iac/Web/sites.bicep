param siteName string
param location string 

var hostingPlanName = '${siteName}-serviceplan'

resource hostingPlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: hostingPlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    tier: 'Standard'
    name: 'S1'
  }
}

resource website 'Microsoft.Web/sites@2020-06-01' = {
  name: siteName
  location: location
  properties: {
    serverFarmId: hostingPlan.id
  }
}

resource connectionString 'Microsoft.Web/sites/config@2020-06-01' = {
  parent: website
  name: 'connectionstrings'
  properties: {
    // defaultConnection: {
    //   value: 'Database=${databaseName};Data Source=${server.properties.fullyQualifiedDomainName};User Id=${administratorLogin}@${serverName};Password=${administratorLoginPassword}'
    //   type: 'MySql'
    // }
  }
}
