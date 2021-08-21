#! /bin/bash
set -eu

#   Execute terraform validate and output results as JSON'
#   Arguments:
#       - DefaultWorkingDirectory: typically equal to '$(System.DefaultWorkingDirectory)/terraform'

DefaultWorkingDirectory=$1
CodeQualityDirectory=$2

cd "$DefaultWorkingDirectory"
mkdir "$DefaultWorkingDirectory"/"$CodeQualityDirectory"/tfval

echo ""
echo -e "\n\n>>> Execute terraform validate"
# Only check, this is do not perform any fixes
(terraform validate -json > "$DefaultWorkingDirectory"/"$CodeQualityDirectory"/tf-validate-output.json)
