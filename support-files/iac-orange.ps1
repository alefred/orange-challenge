# iniciar el arm template con: arm!
$rg = 'orange_rg'

New-AzResourceGroupDeployment `
    -name 'IaC-Orange' `
    -TemplateFile '.\arm-template\iac-orange.json' `
    -webappName 'orangeAppbetatest01' `
    -ResourceGroupName $rg 
