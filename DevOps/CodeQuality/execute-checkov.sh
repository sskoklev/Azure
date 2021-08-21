#! /bin/bash
set -eu

#   Execute checkov security analysis and export logs as JUnit xml.
#
#   Arguments:
#       - DefaultWorkingDirectory: typically equal to '$(System.DefaultWorkingDirectory)/terraform'

DefaultWorkingDirectory=$1
CodeQualityDirectory=$2

cd "$DefaultWorkingDirectory"
mkdir checkovreport
cd "$DefaultWorkingDirectory"/"$CodeQualityDirectory"

echo -e "\n\n>>> Execute Checkov Analysis"
# Note for linting tools we always get the latest
docker pull bridgecrew/checkov
docker run --volume "$DefaultWorkingDirectory":/tf bridgecrew/checkov --directory /tf --output junitxml > "$DefaultWorkingDirectory"/"$CodeQualityDirectory"/Checkov-Report.xml
