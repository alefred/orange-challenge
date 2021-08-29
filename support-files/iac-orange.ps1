# iniciar el arm template con: arm! az login --use-device-code
$rg = 'orangeTest_rg'
az group create --resource-group $rg --location "East US 2"

New-AzResourceGroupDeployment `
    -name 'IaC-Orange' `
    -TemplateFile '.\arm-template\iac-orange.json' `
    -webappName 'orangeARMtest01' `
    -ResourceGroupName $rg 
