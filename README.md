![Alt text](aks-consul-template-vault-agent-dotnet-mssql.png?raw=true "Title")
A Demo to showcase dynamic configuration with settings and secrets for a .NET Application using
 1. Consul 
 2. Consul KV
 3. Consul-template
 4. Vault
 5. Vault dyanmic secrets with MSSQL
 6. Vault agent

The .NET Application, Consul, Vault, MSSQL all  runs in an AKS cluster

The full deploymet  happens through 2 TF modules

1. aks-vault-consul-mssql : Deploy all infra components
2. vault-consul-app-config: Configure everything and deploy app

The custom dtabase image can be created with code in the database/Dockerfile
The app image can be created using the dotnetapp/Dockerfile

Images also available at kaparora/projectapi and  kaparora/mssql . Those are currently being used in the code.

Assumption: you have logged in to azure with az login
You can also set Azure creds as env variables. Check TF documentation

Steps to execute:
Deploy infra:
1. cd tf-aks-vault-consul-mssql
2. copy terraform.tfvars.example terraform.tfvars
3. update terraform.tfvars
4. terraform init
5. terraform plan -out plan.tfplan
6. terraform apply -auto-approve plan.tfplan
7. Wait for deployment to complete
8. Copy output values to tf-vault-consul-app-config/terraform.tfvars
    You can do terraform output ? ../tf-vault-consul-app-config/terraform.tfvars but make sure you remove the toList() from the kubeconfig  value
9. cd ..
10. cd  tf-vault-consul-app-config
11. make sure you have the right values in terraform.tfvars
12. terraform init
13. terraform plan -out plan.tfplan
14. terraform apply -auto-approve plan.tfplan 
15. Wait for deployment to complete
16. Click on the app url, you should see json ouput of the DB rows
17. You can get set the kubeconfig in your machine by using the get-aks-creds.sh  script
18. Checkout the pods with kubectl get pods


