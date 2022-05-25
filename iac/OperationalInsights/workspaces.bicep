
param name string

@description('Daily maximum GB captured by Log Analytics, excess is discarded and not logged')
param dailyQuotaGb int = 10

@description('Daily maximum amount of days the logs are kept in Log Analytics')
param retentionInDays int = 90

@description('skuName of Log Analytics workspace')
param skuName string = 'PerGB2018'

@description('Location')
param location string 

// Resource: Log Analytics Workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: name
  location: location
  properties: {
    sku: {
      name: skuName
    }
    retentionInDays: retentionInDays
    workspaceCapping: {
      dailyQuotaGb: dailyQuotaGb
    }
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}
output id string = logAnalyticsWorkspace.id
