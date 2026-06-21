# Terraform Cloud GitOps Workflow – PoC

## Objective

Implement infrastructure deployment using Terraform Cloud with GitHub VCS workflow:

Infra Team Push
        ↓
Pull Request
        ↓
Terraform Plan
        ↓
Review Plan
        ↓
Merge PR
        ↓
Terraform Apply
        ↓
AWS Infrastructure Updated


---

## Repository Structure

aws-devops-poc/
└── infrastructure-automation/
    └── terraform-files/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── versions.tf


---

## One-Time Setup

Completed configuration:

- Created GitHub repository:
  `aws-devops-poc`

- Created Terraform Cloud workspace:
  `terraform-live`

- Connected GitHub repository to Terraform Cloud using VCS workflow

- Configured working directory:

```text
infrastructure-automation/terraform-files
```

- Configured AWS Dynamic Credentials using:

```text
Terraform-Role
```

Enabled:

- Auto Apply
- Speculative Plans

GitHub branch protection for `main`:

- Require pull request before merging
- Require status checks before merge
- Do not allow bypassing
- Required approvals = 0 (PoC only)


---

## Day-to-Day Workflow

### Step 1: Create a new branch

Never make changes directly on `main`.

```bash
git checkout main
git pull origin main

git checkout -b infra/s3-update
```

Examples:

```text
infra/s3-update
infra/ecs-update
infra/alb-update
infra/monitoring
```

---

### Step 2: Modify Terraform files

Example:

```hcl
variable "bucket_name" {
  default="aws-devops-poc-live-bucket-v2"
}
```

Or add new resources:

```hcl
resource "aws_ecs_cluster" ...
resource "aws_lb" ...
```

---

### Step 3: Commit and push

```bash
git add .

git commit -m "Updated infrastructure configuration"

git push origin infra/s3-update
```

Explanation:

Local Machine
      ↓
GitHub branch updated

No infrastructure changes yet.


---

### Step 4: Create Pull Request

GitHub:

```text
Source:
infra/s3-update

Target:
main
```

---

### Step 5: Terraform Cloud automatically runs Plan

Terraform Cloud detects PR creation:

```text
terraform init
terraform plan
```

Example output:

```text
+ → Create resource

~ → Modify resource

- → Delete resource
```

Example:

```text
Plan:

0 to add
1 to change
0 to destroy
```

Important:

No infrastructure changes happen at this stage.

Only preview is generated.


---

### Step 6: Merge Pull Request

Click:

```text
Merge Pull Request
```

Explanation:

```text
infra/s3-update
        ↓
merged into
        ↓
main
```

---

### Step 7: Terraform Cloud automatically runs Apply

Terraform Cloud detects changes in `main`:

```text
terraform plan
        ↓
terraform apply
```

Example:

```text
Apply complete

Resources: 1 changed
```

---

### Step 8: Verify in AWS

Open AWS Console and verify resources.

Example:

```text
AWS Console
      ↓
S3
      ↓
Buckets
```

---

## Final Flow

Infra Team
     ↓
git checkout -b infra/change-name

     ↓
Modify Terraform files

     ↓
git push origin infra/change-name

     ↓
GitHub Pull Request → main

     ↓
Terraform Cloud
(terraform plan only)

     ↓
Review Plan

     ↓
Merge PR

     ↓
Terraform Cloud
(terraform apply)

     ↓
AWS Infrastructure Updated


---

## Notes

- Never push directly to `main`
- Always create PRs
- `main` remains protected
- Terraform Plan acts as a validation/review stage
- Terraform Apply only happens after merge