#! /bin/bash
set -eu

#   Execute terraform fmt recursively, &
#     'check', this is only report non-compliant files do not make updates to correct the files.
#   Arguments:
#       - DefaultWorkingDirectory: typically equal to '$(System.DefaultWorkingDirectory)/terraform'

DefaultWorkingDirectory=$1

cd "$DefaultWorkingDirectory"

echo -e "\n\n>>> Execute terraform fmt"
(terraform fmt -check -recursive > tf-fmt-output.txt) || true
