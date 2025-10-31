👨‍💻 Author

Students Name

Course

Institution

Instructor













📘 FM-Café Cloud Migration – Software Defined Infrastructure Project

🧩 Overview



This project demonstrates a cloud migration and modernization workflow for the fictional company FM-Café, implementing Software Defined Infrastructure (SDI) principles.

Using Terraform, LocalStack, AWS CLI, Python, and Node.js, the project provisions, automates, and dynamically controls infrastructure resources in a cloud-native, programmable environment.



It serves as the final project under Software Defined Programming / Cloud Infrastructure Automation, illustrating how infrastructure can be managed entirely as software.



🎯 Project Goals



✅ Implement Infrastructure as Code (IaC) using Terraform modules



✅ Simulate AWS services locally using LocalStack



✅ Enable programmable infrastructure control via Python automation scripts



✅ Integrate dynamic configuration management using S3-based feature flags



✅ Demonstrate application-level adaptation via feature toggles in Python and Node.js apps



✅ Showcase DevOps automation and Git version control for all assets



🧱 Project Architecture

fm-cafe-cloud-migration/

│

├── app/                      → Application layer (Node.js \& Python demo apps)

│   ├── read\_feature\_flags.py

│   ├── readFeatureFlags.js

│   └── server.js

│

├── config/                   → Configuration and feature flag management

│   └── feature\_flags.json

│

├── infrastructure/

│   ├── automation/           → Automation and control scripts

│   │   ├── scale\_app.py

│   │   ├── push\_config.ps1

│   │   └── check\_s3.py

│   │

│   └── terraform/            → IaC for network, compute, and storage

│       ├── main.tf

│       ├── variables.tf

│       ├── outputs.tf

│       ├── envs/

│       │   ├── dev.tfvars

│       │   └── prod.tfvars

│       ├── modules/

│       │   ├── network/

│       │   ├── compute/

│       │   └── storage/

│       └── terraform.tfstate

│

└── docs/                     → Screenshots, architecture diagrams, and reports



⚙️ Implementation Steps

STEP 1 – Infrastructure as Code



Built modular Terraform configuration for:



VPC, Subnets, and Route Tables



EC2 instances / Auto Scaling Groups (ASG)



S3 buckets for configuration and storage



Verified using:



terraform init

terraform validate

terraform plan -var-file=envs/dev.tfvars

terraform apply -var-file=envs/dev.tfvars -auto-approve



STEP 2 – Environment Parameterization



Created environment-specific tfvars:



\# envs/dev.tfvars

cidr\_block = "10.0.0.0/16"

public\_subnet\_cidr = "10.0.1.0/24"

app\_instance\_count = 1





Used Terraform workspaces for separation of dev and prod.



STEP 3 – Programmable Control (Python Automation)



Developed scale\_app.py to dynamically adjust app instance count:



python scale\_app.py 3





➜ Updates app\_instance\_count in tfvars and runs terraform apply.



STEP 4 – Dynamic Configuration Management



Created S3-hosted feature flag config (config/feature\_flags.json):



{

&nbsp; "enable\_new\_checkout": true,

&nbsp; "maintenance\_mode": false,

&nbsp; "max\_daily\_transactions": 1000

}





Added PowerShell uploader:



.\\push\_config.ps1 -file "..\\..\\config\\feature\_flags.json" -bucket "fm-cafe-config-bucket"





Application reads config dynamically from S3 or local fallback.



STEP 5 – Application Layer Integration



Python App (read\_feature\_flags.py)



Loads feature toggles from S3 or local JSON.



Demonstrates adaptive app behavior.



Node.js Express App (server.js)



Periodically refreshes flags from S3.



Responds dynamically based on feature toggles:



enable\_new\_checkout → routes to new checkout



maintenance\_mode → returns HTTP 503



🧠 Conceptual Reflection

SDI Principle	Implementation Example

Infrastructure as Code (IaC)	Terraform modules for all infrastructure resources

Programmability	Python automation script calling Terraform CLI

Dynamic Configurability	S3-based JSON configuration and feature flags

Abstraction and Modularity	Separated Terraform modules and tfvars for each environment

Continuous Adaptation	Node app refreshes feature flags every 30 seconds

Local Simulation	LocalStack provides AWS services locally for offline testing

🧰 Tools and Technologies

Category	Tool / Service	Purpose

Cloud Simulation	LocalStack	Mock AWS APIs locally

Infrastructure	Terraform	IaC for provisioning

Automation	Python	Scripted control of infra

App Layer	Node.js / Express	Dynamic web behavior

Configuration	S3 / JSON	Centralized config flags

DevOps	Git + GitHub	Version control \& collaboration

📸 Evidence and Artifacts



Located in the /docs folder:



Terraform Plan \& Apply outputs



AWS CLI command results



Screenshots of running LocalStack \& containers



Application test responses



Configuration and automation scripts in action



🧾 Key Learnings



Software-Defined Infrastructure abstracts physical infrastructure through code and APIs.



LocalStack enables fast, offline AWS prototyping.



Terraform modularization improves scalability and reusability.



Dynamic configuration management supports real-time application adaptation.



Automation scripts bridge DevOps and software programming.



🚀 Next Steps / Future Enhancements



Integrate CI/CD using GitHub Actions



Extend monitoring with AWS CloudWatch or Prometheus



Deploy on real AWS (EC2 + RDS)



Add Secrets Manager and IAM role-based control



Migrate feature flags to AWS Parameter Store or AppConfig





