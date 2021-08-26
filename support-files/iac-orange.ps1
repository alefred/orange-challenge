# iniciar el arm template con: arm!
$rg = 'orange_rg'

New-AzResourceGroupDeployment `
    -name 'IaC-Orange' `
    -TemplateFile 'iac-orange.json' `
    -webappName 'orangeApp00' `
    -ResourceGroupName $rg 
