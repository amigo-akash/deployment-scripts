Commands to run the shell scripts

Make sure to grant the execution permission to both the scripts before executing them.

Make sure to create a deployment directory inside this repository as backup scripts will store all the backups there.

command: 
  ./create_deployment_backup.sh <repo-name> <env-name>
  ex: ./create_deployment_backup.sh deployment-scripts dev

  ./delete_deployment.sh <repo-name> <json-file>
   ex:  ./delete_deployment.sh deployment-scripts ./deployments/deployments__dev__deployment-scripts.json
