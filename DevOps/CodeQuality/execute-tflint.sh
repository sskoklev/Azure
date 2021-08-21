#! /bin/bash
set -eu

#   Execute Terraform tflint - A 3rd party (not Hashicorp Terraform product)
#   1. Download Azure specific tfline ruleset.
#   2. Download tflint
#   3. Execute tflint exporting issues to junit xml file (which is later published) as a test result in Azure Pipelines
#   Arguments:
#       - DefaultWorkingDirectory: typically equal to '$(System.DefaultWorkingDirectory)/terraform'

DefaultWorkingDirectory=$1
CodeQualityDirectory=$2

cd "$DefaultWorkingDirectory"
# Note for linting tools we always get the latest
echo -e "\n\n>>> Install tflint (3rd party)"
curl -L "$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")" > tflint.zip && unzip tflint.zip && rm tflint.zip
chmod +x "$DefaultWorkingDirectory"/tflint

echo -e "\n\n>>> Prepare folders for tflint-ruleset-azurerm (3rd party)"
cd /home/vsts
mkdir .tflint.d
cd .tflint.d
mkdir plugins
cd /home/vsts/.tflint.d/plugins

echo -e "\n\n>>> Install tflint-ruleset-azurerm (3rd party)"
# Note for linting tools we always get the latest
curl -L "$(curl -s https://api.github.com/repos/terraform-linters/tflint-ruleset-azurerm/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")" > tflint-ruleset-azurerm.zip && unzip tflint-ruleset-azurerm.zip && rm tflint-ruleset-azurerm.zip
cd /home/vsts/.tflint.d/plugins
chmod +x /home/vsts/.tflint.d/plugins/tflint-ruleset-azurerm

cd "$DefaultWorkingDirectory"

echo -e "\n\n>>> Execute tflint"
"$DefaultWorkingDirectory"/tflint --enable-plugin=azurerm --module --format junit > "$DefaultWorkingDirectory"/"$CodeQualityDirectory"/tflint.xml
