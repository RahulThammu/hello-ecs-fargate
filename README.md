
 (Application source code, Dockerfiles, or any app-related files)
│
└── infra                          # Terraform Infrastructure Code
    │
    ├── Level1-network             # Base networking layer
    │   ├── dev.tfvars             # Environment-specific variables (dev)
    │   ├── provider.tf            # Provider config (AWS, region, backend)
    │   ├── vars.tf                # Variable definitions
    │   ├── vpc.tf                 # VPC, Subnets, IGW, NAT, Route Tables
    │   └── output.tf              # Outputs (vpc_id, subnet_ids, etc.)
    │
    ├── Level2-IAM                 # Identity and Access Management layer
    │   └── (IAM roles, policies, service accounts for ECS, CI/CD, etc.)
    │
    ├── Level3-PAAS                # Platform Services layer
    │   └── (ECS cluster, Fargate services, RDS, or other PaaS resources)
    │
    └── Level4-Devops              # CI/CD pipelines
        ├── aws                    # AWS CI/CD automation
        │   └── (CodePipeline, CodeBuild, CodeDeploy definitions)
        │
        └── azure                  # Azure CI/CD automation
            └── (Azure DevOps pipeline YAML or Terraform configs)

### *Level 1 – Network*
- Provisions VPC, subnets (public/private), route tables, IGW, NAT gateways.
- Provides outputs (vpc_id, public_subnets, private_subnets) consumed by higher levels.

### *Level 2 – IAM*
- Creates IAM roles, policies, and service accounts.
- Enables least-privilege access for ECS tasks, CI/CD pipelines, and other services.

### *Level 3 – PAAS*
- Deploys ECS with Fargate, RDS, and related platform services.
- Integrates with networking and IAM from previous levels.

### *Level 4 – DevOps*
- *AWS* → CodePipeline + CodeBuild + CodeDeploy for application deployment.
- *Azure* → Azure DevOps pipelines for multi-cloud CI/CD support.