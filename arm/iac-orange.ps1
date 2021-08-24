# iniciar el arm template con: arm!
$rg = 'a4s_rg_dev'

New-AzResourceGroupDeployment `
    -name 'IaC-Orange' `
    -TemplateFile 'iac-orange-pivot.json' `
    -webappName 'orangeApp00' `
    -ResourceGroupName $rg 
