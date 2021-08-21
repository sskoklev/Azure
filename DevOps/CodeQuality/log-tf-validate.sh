#! /bin/bash
set -eu

#   Publish terraform validate logs.
#   This command cannot be exported as JUnit XML hence the need to parse the JSON
#     and raise as errors or warnings rather than publish as Test Results.
#   Arguments:
#       - DefaultWorkingDirectory: typically equal to '$(System.DefaultWorkingDirectory)/terraform'

DefaultWorkingDirectory=$1
CodeQualityDirectory=$2

echo -e "\n\n>>> Install jq"
sudo apt-get install jq

echo -e "\n\n>>> Log terraform validate"
# Get the 4 data elements of interest
dataset=$(cat "$DefaultWorkingDirectory"/"$CodeQualityDirectory"/tf-validate-output.json | jq '[.diagnostics[] | {severity,summary,detail,filename: .range.filename}]')
for row in $(echo "${dataset}" | jq -r '.[] | @base64'); do
    _jq() {
     echo "${row}" | base64 --decode | jq -r "${1}"
    }

   severity=$(_jq '.severity')
   summary=$(_jq '.summary')
   detail=$(_jq '.detail')
   filename=$(_jq '.filename')

   shopt -s nocasematch;
   if [[ $severity =~ "error" ]]
   then
      echo "##vso[task.logissue type=error;]terraform validate issue $(if [ -z "$filename" ]; then echo ""; else echo "in $filename"; fi): $summary: $detail"
   else
      echo "##vso[task.logissue type=warning;]terraform validate issue $(if [ -z "$filename" ]; then echo ""; else echo "in $filename"; fi): $summary: $detail"
   fi
done