# qterraform

Github repository
Terraform Resources and Code Git Location: ([https://github.com/anshulc55/terraform])

## Install Terraform

### Install Terraform on Mac Machine -

To Install the Terraform on MAC Machine, just copy-paste the below script in your local Machine and execute this script. Or you can execute the given commands in Script one by one but complete script execution is preferred over single line Command Execution.

mac-terraform-install.sh

```shell
brew install jq
brew install wget
cd ~
version=$(curl https://api.github.com/repos/hashicorp/terraform/releases/latest --silent | jq ".tag_name" -r)
version=$(echo $version | sed 's/v//g') # get rid of 'v' from version number
echo "Installing Terraform $version."
url="https://releases.hashicorp.com/terraform/$version/terraform_$(echo $version)_darwin_amd64.zip"
wget $url
unzip "terraform_$(echo $version)_darwin_amd64.zip"
chmod +x terraform
sudo mv terraform /usr/local/bin/
echo "Terraform $version installed."
rm "terraform_$(echo $version)_darwin_amd64.zip"
echo "Install files cleaned up."
```

### Install Terraform on Windows 10 -

1️⃣ Download the appropriate version of Terraform from HashiCorp’s download page. In my case, it’s the Windows 64-bit version.

2️⃣ Make a folder on your C:\ drive where you can put the Terraform executable. I prefer to place installers in a subfolder (e.g. C:\tools) where you can put binaries.

3️⃣ After the download finishes, go find it in File Explorer. Extract the zip file to the folder you created in step 2.

4️⃣ Open your Start Menu and type in “environment” and the first thing that comes up should be Edit the System Environment Variables option. Click on that and you should see this window.

![alt text](./images/image.png)

5️⃣ Click on Environment Variables… at the bottom and you’ll see this:

![alt text](./images/image-1.png)

6️⃣ Under the bottom section where it says System Variables, find one called Path and click edit. You’ll then see a list of where to find the binaries that Windows might need for any given reason.

7️⃣ Click New and add the folder path where terraform.exe is located to the bottom of the list. It should look like this when you finish.

![alt text](./images/image-2.png)

8️⃣ Click OK on each of the menus you’ve opened up until there’s no more left.

9️⃣ To make sure that Windows detects the new path, open a new CMD/PowerShell prompt and enter refreshenv. or close the opened PowerShell window and Open New One.

🔟 Verify the installation was successful by entering terraform --version. If it returns a version, you’re good to go.

## Run Terraform

__Initialize Backend__
```shell
terraform init
```
__Format Terraform code__
```shell
terraform fmt
```
__Validate Terraform Code__
```shell
terraform validate
```

__Start Terraform Plan__
```shell
terraform plan
```
```shell
# Start Terraform Plan & export output
terraform plan -out=plan.out
# Show Terraform plan.out File
terraform show plan.out
# Convert plan.out to plan.json
terraform show -json plan.out > plan.json
# Export Specific Resource from plan.json File
jq '.resource_changes[].address' plan.json
```

__Apply Terraform code__
```shell
terraform apply
# Apply Terraform plan.out File
terraform apply plan.out
# Apply Terraform code with Auto Approve
terraform apply -auto-approve
```

__Show Terraform Output__
```shell
terraform output
terraform output eip-mysql-dev-0
terraform state list | grep lb
```

__Destroy Terraform code__
```shell
terraform destroy -auto-approve
```
```shell
# Destroy one specific resource:
terraform destroy -target=aws_instance.mysql_dev_0
terraform destroy -target=aws_lb_target_group.app_tg
terraform destroy -target=aws_ecs_service.app-service
terraform plan -destroy -target=aws_instance.mysql_dev_0
```
```shell
# Remove from state (does NOT destroy infra)
terraform state rm aws_instance.mysql_dev_0
```

```shell
# Plan Terraform Workspace for Specific Environment
terraform workspace $WORKSPACE $ENV
# Select Terraform Workspace Environment
terraform workspace select $ENV
terraform apply
```

```shell
terraform console
data.aws_availability_zones.avilable.names
```

```shell
grep -R "resource \"aws_lb\"" .
grep -R "resource \"aws_lb_target_group\"" .
grep -R "resource \"aws_ecs_service\"" .
```

## Terraform Info

```shell
terraform init
terraform fmt
terraform validate
terraform plan
```

```shell
terraform force-unlock be956125-f279-13fd-6a2f-594d623df862
```
```shell
terraform apply
```
```shell
ls -a
rm .terraform.tfstate.lock.info
```
```shell
terraform destroy -target=module.eks
```
```shell
terraform state list
terraform plan
terraform apply --auto-approve
terraform apply -lock=false
```

## ✅ Recommended: S3 Remote Backend (with DynamoDB locking)

### 1️⃣ Create S3 bucket (one time)
```shell
aws s3api create-bucket --bucket terraform-state-bucket-qasem --region $AWS_REGION
```

__Enable versioning (strongly recommended):__
```shell
aws s3api put-bucket-versioning --bucket terraform-state-bucket-qasem --versioning-configuration Status=Enabled
```

### 2️⃣ (Optional but best practice) Create DynamoDB table for locking
```shell
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```
```json
{
    "TableDescription": {
        "AttributeDefinitions": [
            {
                "AttributeName": "LockID",
                "AttributeType": "S"
            }
        ],
        "TableName": "terraform-locks",
        "KeySchema": [
            {
                "AttributeName": "LockID",
                "KeyType": "HASH"
            }
        ],
        "TableStatus": "CREATING",
        "CreationDateTime": "2025-12-16T14:43:44.517000+03:00",
        "ProvisionedThroughput": {
            "NumberOfDecreasesToday": 0,
            "ReadCapacityUnits": 0,
            "WriteCapacityUnits": 0
        },
        "TableSizeBytes": 0,
        "ItemCount": 0,
        "TableArn": "arn:aws:dynamodb:eu-central-1:907244240513:table/terraform-locks",
        "TableId": "085d86a2-e2f7-462a-ac46-ecb7b959a111",
        "BillingModeSummary": {
            "BillingMode": "PAY_PER_REQUEST"
        },
        "DeletionProtectionEnabled": false
    }
}
```

### 3️⃣ Configure Terraform backend
__Add this to backend.tf (or inside terraform {}):__
```json
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-qasem"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```
📌 __After this:__<br>
① Terraform writes state to S3<br>
② State is updated after every apply<br>
③ DynamoDB prevents concurrent applies<br>
④ S3 versioning gives rollback safety<br>

### 4️⃣ Initialize backend
```shell
terraform init
```

### 🔁 What happens after this?
__Every time you run:__
```shell
terraform apply
```
__Terraform will:__<br>
① Lock state in DynamoDB<br>
② Apply changes<br>
③ Upload updated terraform.tfstate to S3<br>
④ Release lock<br>

### ✅ No manual upload needed.
__🔒 IAM permissions required__
The IAM role/user running Terraform must have:
```json
{
  "Effect": "Allow",
  "Action": [
    "s3:GetObject",
    "s3:PutObject",
    "s3:ListBucket"
  ],
  "Resource": [
    "arn:aws:s3:::my-terraform-state-bucket",
    "arn:aws:s3:::my-terraform-state-bucket/*"
  ]
}
```
__Plus DynamoDB permissions if locking is enabled.__

### 🧪 Verify state is in S3
```shell
aws s3 ls s3://terraform-state-bucket-qasem/eks/
```
__🚫 Common mistakes to avoid__<br>
❌ Using local backend + scripts<br>
❌ Committing terraform.tfstate to Git<br>
❌ Sharing state files without locking<br>
❌ Using the same state file for multiple environments<br>

__🟢 Bonus: Separate state per environment__<br>
key = "eks/${terraform.workspace}/terraform.tfstate"<br>

❌ Case 1: Local state (no remote backend)<br>
__Worst case__<br>
What happens:<br>
① Both users run terraform apply<br>
② Each has their own local terraform.tfstate<br>
③ Terraform has no idea the other apply exists<br>

__Result:__<br>
Resources get created/modified twice<br>
① State files diverge<br>
② Future applies cause deletes, recreates, or drift<br>
③ Manual recovery required<br>

⚠️ This is how infrastructures get corrupted.<br>
⚠️ Case 2: Remote state without locking<br>

> Example: S3 backend without DynamoDB

__What happens:__<br>
① User A reads state<br>
② User B reads same state<br>
③ Both apply changes<br>
④ Last writer wins<br>

__Result:__<br>
① State file overwritten<br>
② Lost updates<br>
③ Infrastructure may be partially updated<br>
④ Terraform might destroy resources unexpectedly later<br>

✅ Case 2: Remote state with locking (Best practice)

> Example: S3 + DynamoDB

__What happens:__<br>
① User A runs terraform apply<br>
② Terraform acquires a lock in DynamoDB<br>
③ User B runs terraform apply<br>
④ User B is blocked<br>
⑤ User B sees:<br>

Error acquiring the state lock
Lock Info:
  ID:        xxxxx
  Operation: OperationTypeApply
  Who:       userA@hostname

__Result:__<br>
① Only one apply runs at a time<br>
② State remains consistent<br>
③ No corruption<br>
* User B must wait or retry<br>

__🧠 Important details__<br>
__What if User A crashes?__<br>
① Lock remains<br>
② User B cannot apply<br>
③ Fix (safe):<br>
```shell
terraform force-unlock <LOCK_ID>
```

__What about terraform plan?__<br>
① Multiple users can run plan safely<br>
② plan does not lock state (read-only)<br>
```yaml
🔒 Recommended setup (must-have)
terraform {
  backend "s3" {
    bucket         = "my-tf-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```
__🚨 What NOT to do__<br>
❌ Run Terraform from multiple laptops<br>
❌ Share state without locking<br>
❌ Manually edit state files<br>
❌ Run applies outside CI/CD<br>

__✅ Best practice in teams__<br>
① Single CI/CD pipeline runs terraform apply<br>
② Developers run terraform plan only<br>
③ Locking enabled<br>
④ State stored remotely<br>

__🟢 Summary__<br>
Setup   Outcome<br>
① Local state   💥 Corruption<br>
② Remote no lock        ⚠️ Lost updates<br>
③ Remote + lock<br>
