# iniciar el arm template con: arm!
$rg = 'a4s_rg_dev'

New-AzResourceGroupDeployment `
    -name 'IaC-Orange' `
    -ResourceGroupName $rg `
    -TemplateFile 'iac-orange.json' `
    -webappName 'orangeApp00'