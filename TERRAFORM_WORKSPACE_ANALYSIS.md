# Terraform Workspace Deep Analysis (Read-only Report)

Date: 2025-12-24  
Workspace: `D:/terraform`

This document is a deep, **read-only** analysis of the Terraform workspace structure, patterns, and how the stacks appear to work together. It is based on repository scanning (directory listing, text search across `*.tf`, and spot-reading key files). It does **not** claim that every single file was line-by-line audited; where something is not fully confirmed, it is explicitly labeled.

---

## 0) Executive Summary (What this repo is)

This workspace contains:

1. **Learning / concept examples** (Terraform basics, loops, dynamic blocks, provisioners, remote state examples).
2. **A RoboShop infrastructure implementation** in multiple “flavors”:
   - `03-roboshop-infra-standard/` – a multi-stack implementation using **local modules** stored in `02-terraform-modules-projects/`.
   - `04-roboshop-Infra-DEV/` – environment-specific split-stack (DEV), mostly using **GitHub module sources**.
   - `05-roboshop-Infra-PROD/` – environment-specific split-stack (PROD), mostly using **GitHub module sources**.
3. **Terraform modules** and “module projects” under `02-terraform-modules-projects/`.
4. Some application/deploy repos (e.g., `06-catalogue/`, `07-catalogue-deploy/`) and Jenkins shared libraries.

A major architectural decision used throughout RoboShop stacks: **cross-stack dependency sharing through AWS SSM Parameter Store**, rather than `terraform_remote_state`.

---

## 1) Top-level folder inventory (What each major folder is for)

### 00-ansible-setup-ec2-route53/
- Terraform + ansible-driven EC2/Route53 patterns (appears to be tutorial-like).

### 01-terraform-concepts/
Contains multiple concept demos:
- `01-simple-ec2/` – basic EC2 + SG.
- `02-ec2-sg-subnet-vpc/` – EC2 with subnet/VPC/SG basics.
- `03-conditions-tf/` – conditions and variable usage.
- `04-count-route53-locals-tf/` – `count`, Route53, locals.
- `05-foreach/` – `for_each` examples.
- `06-dynamic-block/` – dynamic blocks.
- `07-remote-state-for-tfstate-file/` – remote backend practice.
- `08-tfstate-env/` – environment folders with backend configs.
- `09-vpc-public-subnet-sg-route-table-tf/` – VPC/subnet/route table patterns.
- `10-terraform-ec2/` – module usage for EC2.
- `11-terraform-module/` – module example.
- `12-roboshop_infra/` and `13-terraform_aws_vpc/` – VPC module patterns.
- `14-jenkins-master-nodes/` – Jenkins master/slave infra.
- `15-provisioners/` – provisioners examples.

### 02-terraform-modules-projects/
- Contains reusable modules/projects.
- Notably:
  - `02-terraform-aws-vpc-advanced/` (VPC + NAT + route tables + db subnet group + optional peering).
  - `03-terraform-aws-security-group/` (security group with dynamic ingress).

### 03-roboshop-infra-standard/
A “standard” RoboShop infrastructure split into multiple sub-stacks (intended to be applied in a particular sequence). Contains `terraform.tfstate` in this folder (local state file exists here).
Subfolders include:
- `01-vpc/`
- `02-firewall/`
- `03-vpn/`
- `04-mongodb/`
- `05-app-alb/`
- `06-catalogue/`
- `07-web-alb/`
- `08-web-server/`
- `09-redis/`
- `10-user/`
- `11-cart/`
- `12-mysql/`
- `13-shipping/`
- `14-RabbitMQ/`
- `15-payment/`

### 04-roboshop-Infra-DEV/
A DEV split-stack version with:
- `01-vpc/`, `02-firewall/`, `03-vpn/`, `04-mongodb/`, `05-app-alb/`, `06-IAM/`

### 05-roboshop-Infra-PROD/
A PROD split-stack version with:
- `01-vpc/`, `02-firewall/`, `03-vpn/`, `04-mongodb/`, `05-app-alb/`, `06-IAM/`

### 06-catalogue/ + 07-catalogue-deploy/
- Application repo (`06-catalogue/`) with `package.json`, `server.js` etc.
- `07-catalogue-deploy/` includes Terraform and a `terraform.tfstate` (local state file exists here).

### 08-Jenkins-Shared-Libraries/
- Jenkins shared library scripts.

### 09-Dynamic-Website-College/
- Smaller Terraform projects: a “Simple-Way” EC2/VPC build and an S3 static website project.

---

## 2) Global Terraform patterns (Providers, Regions, Versions)

### AWS Provider
- Many stacks declare:
  - `required_providers { aws { source = "hashicorp/aws", version = "~> 6.0" } }`
- Region is commonly `ap-south-1` (Mumbai) for RoboShop stacks.
- Some concept examples use other versions/regions (example observed: `15-provisioners` using `us-east-1` and AWS provider `5.15.0`).

### Terraform CLI Version
- The root project does not appear to pin a single `required_version` at the workspace root.
- Some downloaded module code under `.terraform/modules/...` includes `required_version = ">= 1.3.2"`.

### Lockfiles
- `.terraform.lock.hcl` files were visible inside some subprojects (notably under `03-roboshop-infra-standard/01-vpc/`), but lockfiles may not exist everywhere.

---

## 3) State & Backend strategy (VERY IMPORTANT)

### S3 Remote Backend (RoboShop stacks)
Most RoboShop stacks use:
- `backend "s3"` with:
  - bucket: `sarthak-remote-tfstate`
  - region: `ap-south-1`
  - dynamodb_table: `sarthak-tfstate-lock`
  - key: varies per stack

This is a standard and good pattern for remote state + state locking.

### Potential backend key collisions (DEV vs PROD)
This is a high-impact observation:
- `04-roboshop-Infra-DEV/06-IAM/provider.tf` uses `key = "iam"`.
- `05-roboshop-Infra-PROD/06-IAM/provider.tf` also uses `key = "iam"`.

Similarly:
- `04-roboshop-Infra-DEV/05-app-alb/provider.tf` uses `key = "app-alb"`.
- `05-roboshop-Infra-PROD/05-app-alb/provider.tf` also uses `key = "app-alb"`.

If both environments are meant to be independent, sharing the same bucket+key means:
- One environment can overwrite the other’s state.
- A `terraform destroy` from one folder can target resources tracked by the other.

(If you are intentionally using one state for both envs, then names/tags must fully separate resources; but this is unusual and risky.)

### Local state files in repo
Some folders contain `terraform.tfstate` locally (observed examples):
- `03-roboshop-infra-standard/terraform.tfstate`
- `07-catalogue-deploy/terraform.tfstate`

This indicates some runs may have used local state rather than remote backend (or the file is leftover). If a module uses remote backend, Terraform usually won’t keep a persistent `terraform.tfstate` locally (except transient state during operations); so these likely reflect either older runs or separate projects.

---

## 4) Cross-stack integration pattern (SSM Parameter Store instead of terraform_remote_state)

### Key finding
No `data "terraform_remote_state" ...` usage was found in the workspace. Instead, RoboShop stacks depend on each other via **AWS SSM Parameter Store**.

### How it works
1. Producer stacks write essential outputs into SSM parameters:
   - VPC stack writes:
     - `/roboshop/<env>/vpc_id`
     - `/roboshop/<env>/public_subnet_ids`
     - `/roboshop/<env>/private_subnet_ids`
     - `/roboshop/<env>/database_subnet_ids`
   - Firewall stack writes SG IDs for components, e.g.:
     - `/roboshop/<env>/catalogue_sg_id`
     - `/roboshop/<env>/mongodb_sg_id`
     - etc.
   - App ALB stack writes listener ARN:
     - `/roboshop/<env>/app_alb_listener_arn`
   - Web ALB stack writes:
     - `/roboshop/<env>/web_alb_listener_arn`

2. Consumer stacks read those values via `data "aws_ssm_parameter" ...`.

### Implication: Strict apply order
Because stacks read values produced by other stacks:
- VPC must run before anything needing `vpc_id/subnets`.
- Firewall/SG stack must run before instances/ASGs that need SG IDs.
- ALB listener stacks must run before services that create `aws_lb_listener_rule`.

If the parameters do not exist yet, Terraform plans will fail.

---

## 5) RoboShop “standard” architecture (03-roboshop-infra-standard)

This is the most complete RoboShop layout in the repo. The structure suggests a pipeline of stacks.

### 5.1 01-vpc (Network foundation)
- Uses module `../../02-terraform-modules-projects/02-terraform-aws-vpc-advanced`.
- Enables VPC peering to default VPC (observed `is_peering_required = true` in `main.tf`).
- Writes critical outputs to SSM via `parameters.tf`.

Produced artifacts:
- VPC ID, subnet IDs (SSM).

### 5.2 02-firewall (Security groups + security group rules)
- Creates a set of SGs (vpn, mongodb, catalogue, user, redis, cart, mysql, shipping, rabbitmq, payment, app_alb, web, web_alb).
- Uses a reusable SG module.
- Adds explicit SG rules connecting components.

Notable design intent:
- Create a VPN SG that allows your current public IP (via `data "http" "myip"`) to SSH.
- Allow SSH (22) to app SGs only from VPN SG.
- Allow app-to-app ports (mongodb, redis, mysql, rabbitmq, alb to apps, etc.).

Produced artifacts:
- SG IDs in SSM (so other stacks can reuse them).

### 5.3 03-vpn (VPN instance)
- Provisions an EC2 instance meant to act as a “VPN/bastion-like” access point (resource `aws_instance vpn_instance` observed).
- Typically should attach to the `vpn` SG from the firewall stack via SSM.

### 5.4 04-mongodb / 09-redis / 12-mysql / 14-RabbitMQ (Data-tier instances)
Observed resource patterns:
- `aws_instance` per component (mongodb, redis, mysql, rabbitmq).
- The `mongodb` stack stores a MongoDB URL into SSM (`mongodb_url`).
- Route53 records are created for some components using `terraform-aws-modules/route53/aws//modules/records`.

### 5.5 05-app-alb (Internal application ALB)
Observed patterns:
- `aws_lb` with `internal = true` (private ALB).
- `aws_lb_listener` with a default fixed-response.
- Writes listener ARN to SSM.
- Creates Route53 wildcard record `*.app` in zone `stallions.space` via `terraform-aws-modules/route53/aws//modules/records`.

Produced artifacts:
- Listener ARN in SSM.
- DNS record(s) for app subdomain.

### 5.6 06-catalogue / 10-user / 11-cart / 13-shipping / 15-payment (App services)
Observed patterns (catalogue example is representative):
- `aws_lb_target_group` per service.
- `aws_launch_template` with:
  - AMI selected via `data "aws_ami"`.
  - `user_data` from a script file (e.g., `08-catalogue.sh`).
  - SG IDs from SSM.
- `aws_autoscaling_group` attaches to the target group.
- `aws_lb_listener_rule` forwards requests to the service target group based on host header (e.g., `catalogue.app.stallions.space`).

### 5.7 07-web-alb + 08-web-server (Public entry)
Observed patterns:
- `07-web-alb` provisions an internet-facing ALB (resource `aws_lb web_alb`).
- Uses ACM certificate resources:
  - `aws_acm_certificate`
  - `aws_route53_record` for validation
  - `aws_acm_certificate_validation`
- Creates HTTPS listener.
- Writes web ALB listener ARN to SSM.

`08-web-server` likely provisions web tier instances/ASG that connect to the public ALB.

---

## 6) RoboShop DEV and PROD stacks (04-roboshop-Infra-DEV, 05-roboshop-Infra-PROD)

These follow a similar split-stack approach, but appear less “fully expanded” in the folder tree compared to `03-roboshop-infra-standard`.

### Similarities
- Same AWS region pattern (`ap-south-1`).
- Same S3 backend bucket and DynamoDB lock table.
- Same SSM Parameter Store interface between stacks.

### Differences
- Some backend keys include env suffixes (e.g., VPC keys differ: `vpc-roboshop-dev` vs `vpc-roboshop-prod`).
- Some backend keys do not include env (IAM and app-alb appear shared). This is potentially dangerous unless intentional.

---

## 7) Terraform modules (02-terraform-modules-projects)

### 7.1 VPC module: 02-terraform-aws-vpc-advanced
Key responsibilities:
- Creates VPC, IGW.
- Creates public/private/database subnets.
- Creates route tables and associations.
- Creates NAT gateway + EIP.
- Creates DB subnet group.
- Optional VPC peering to default VPC and routes.

Notable design details:
- Availability zones are taken from AWS dynamically and truncated to 2 (`slice(..., 0, 2)` in `locals.tf`).
- Variables validate that public/private/database subnet CIDR lists each have exactly 2 elements.

### 7.2 Security group module: 03-terraform-aws-security-group
Key responsibilities:
- Creates a single security group with:
  - A dynamic `ingress` block driven by `security_group_ingress_rule`.
  - A default allow-all egress rule.
- Outputs the SG ID.

This module is used heavily by RoboShop firewall stacks.

---

## 8) Non-RoboShop Terraform projects in this repo

### 8.1 07-catalogue-deploy/terraform
This appears to be a “build an AMI + set up service” workflow:
- Creates an EC2 instance.
- Sets its state.
- Builds an AMI from it (`aws_ami_from_instance`).
- Creates a target group, launch template, autoscaling group, scaling policy, and listener rule.
- Reads RoboShop foundation values from SSM (vpc_id, sg_id, subnets, listener ARN).

This project contains a local `terraform.tfstate`.

### 8.2 09-Dynamic-Website-College
Two distinct projects:
- `Simple-Way/` – a basic VPC/subnet/igw/rt/sg/ec2 deployment.
- `06-s3-static website/` – creates an S3 bucket configured as a public static website with an uploaded `index.html` object.

---

## 9) Observed AWS resource types (Catalog of what is used)

Based on repo-wide search, the following AWS resources are used:

Networking:
- `aws_vpc`, `aws_subnet`, `aws_internet_gateway`, `aws_route_table`, `aws_route`, `aws_route_table_association`
- `aws_nat_gateway`, `aws_eip`
- `aws_vpc_peering_connection`
- `aws_db_subnet_group`

Security:
- `aws_security_group`
- `aws_security_group_rule` and also newer style in some places (`aws_vpc_security_group_ingress_rule`, `aws_vpc_security_group_egress_rule` in Dynamic-Website)

Compute:
- `aws_instance`
- `aws_launch_template`
- `aws_autoscaling_group`
- `aws_autoscaling_policy`

Load balancing:
- `aws_lb`, `aws_lb_listener`, `aws_lb_listener_rule`, `aws_lb_target_group`

IAM:
- `aws_iam_role`, `aws_iam_role_policy_attachment`, `aws_iam_instance_profile`

SSM Parameter Store:
- `aws_ssm_parameter` (used as the cross-stack contract)

DNS / Certificates:
- Route53 records via module `terraform-aws-modules/route53/aws//modules/records`
- In web-alb: `aws_route53_record` (used for ACM validation)
- `aws_acm_certificate`, `aws_acm_certificate_validation`

Storage:
- `aws_s3_bucket`, `aws_s3_bucket_policy`, `aws_s3_bucket_public_access_block`, `aws_s3_bucket_object`

---

## 10) Operational workflow (How to run this repo, conceptually)

### RoboShop (standard)
A typical apply order based on SSM dependencies would be:
1. `03-roboshop-infra-standard/01-vpc`
2. `03-roboshop-infra-standard/02-firewall`
3. `03-roboshop-infra-standard/03-vpn`
4. `03-roboshop-infra-standard/04-mongodb` (and other data services)
5. `03-roboshop-infra-standard/05-app-alb`
6. `03-roboshop-infra-standard/06-catalogue` (and other apps)
7. `03-roboshop-infra-standard/07-web-alb`
8. `03-roboshop-infra-standard/08-web-server`

### DEV/PROD
Similar, but the folder set is smaller.

### Destroy workflow warning
Because the stacks are connected via SSM parameters and shared remote backends:
- Destroying a “producer” stack first (e.g., VPC or firewall) may break the ability to plan/destroy consumer stacks.
- Backend key collisions (DEV vs PROD) can cause the wrong resources to be targeted.

---

## 11) Notable risks / issues (Actionable observations)

These are not “changes” — just analysis findings.

1. **DEV vs PROD remote backend key collisions** (`iam` and `app-alb`) can cause environment cross-talk.
2. **SSM as the cross-stack contract** is workable but requires careful apply/destroy ordering and consistent naming conventions.
3. **Local terraform.tfstate files** exist in some places; ensure you know which projects are actually on remote state vs local state.
4. The firewall stack uses an external HTTP service to read your current public IP for VPN ingress. That means:
   - Plans can change when your IP changes.
   - Runs depend on external availability of that endpoint.

---

## 12) What I can do next

If you want, tell me your exact goal (examples):
- “Explain the correct apply/destroy order for DEV end-to-end.”
- “Why is my app ALB listener rule failing?”
- “How do I prevent DEV/PROD state conflicts?”
- “How do I refactor to use terraform_remote_state instead of SSM?”

…and I’ll answer precisely with references to the relevant folders/files.
