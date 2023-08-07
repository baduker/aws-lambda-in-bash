tf-init:
	terraform init

tf-plan:
	terraform fmt && terraform validate && terraform plan -out lambda-in-bash-plan

tf-apply:
	terraform fmt && terraform apply lambda-in-bash-plan

tf-refresh:
	terraform fmt && terraform apply -refresh-only -auto-approve
