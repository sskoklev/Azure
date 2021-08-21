#! /bin/bash
set -eu

#   Execute terraform graph and output results as svg file.
#   Terraform gaph output a 'dot' file.
#   Docker image is use as 'dot' file requires Graphviz tool to convert to another format, eg svg
#
#   Execute terraform graph beautifier and output results as html file.
#
#   Arguments:
#       - DefaultWorkingDirectory: typically equal to '$(System.DefaultWorkingDirectory)/terraform'
#       - CodeQualityDirectory: typically equal to '$(System.DefaultWorkingDirectory)/terraform/codequality'

DefaultWorkingDirectory=$1
CodeQualityDirectory=$2

cd "$DefaultWorkingDirectory"

# Terraform Graph

echo ""
echo -e "\n\n>>> Execute terraform graph"

(terraform graph -draw-cycles | docker run --rm -i nshine/dot > "$DefaultWorkingDirectory"/"$CodeQualityDirectory"/tf-graph.png)

# Terraform Graph Beautifier

echo -e "\n\n>>> Install tar to unzip"
sudo apt-get install -y tar

echo -e "\n\n>>> Install Terraform Graph Beautifier"

cd "$DefaultWorkingDirectory"
curl -L "$(curl -s https://api.github.com/repos/pcasteran/terraform-graph-beautifier/releases/latest | grep -o -E "https://.+?_Linux_x86_64.tar.gz")" > terraform-graph-beautifier.tar.gz && tar xvzf terraform-graph-beautifier.tar.gz && rm terraform-graph-beautifier.tar.gz

echo -e "\n\n>>> Execute Terraform Graph Beautifier"

(terraform graph | "$DefaultWorkingDirectory"/terraform-graph-beautifier > "$DefaultWorkingDirectory"/"$CodeQualityDirectory"/tf-graph-beautifier.html )
