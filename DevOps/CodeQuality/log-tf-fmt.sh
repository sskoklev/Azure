#! /bin/bash
set -eu

#   Publish terraform fmt logs.
#   This command cannot be exported as JUnit XML hence the need to parse the JSON
#     and raise as errors or warnings rather than publish as Test Results.
#   Arguments:
#       - DefaultWorkingDirectory: typically equal to '$(System.DefaultWorkingDirectory)/terraform'

DefaultWorkingDirectory=$1

cd "$DefaultWorkingDirectory"

echo -e "\n\n>>> Log terraform fmt"
input="$DefaultWorkingDirectory"/tf-fmt-output.txt
while IFS= read -r line
do
    echo "##vso[task.logissue type=warning;]terraform fmt found an issue in: $line"
done < "$input"

