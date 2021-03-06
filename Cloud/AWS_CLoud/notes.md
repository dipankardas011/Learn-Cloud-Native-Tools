# AWS Certified Cloud Practitioner(CLF-C01)

## All the Certificates
![](./Screenshot%202022-05-11%20221406.png)

# What is Cloud Computing
![](./0001.png)

## Evolution
![](./0002.png)

> **NOTE** CSP -> Cloud Service Providers
![](0003.png)
## What is a CSP?
![](./0004.png)

## Landscape
![](./0005.png)

## Garter Magic Quadrant
![](./00006.png)

# Types of Cloud Service (Cloud Computing)
![](./0006.png)

![](./0007.png)

# Dedicated or Physical server
![](./0008.png)
Used for High performance task like ML, Systems Every close together
what kind of vertiualization you want

# VMs
It virtualizes the Physical computer
![](./0009.png)

# Containers
![](./00010.png)
It Virtualizes the OS

# Functions
![](./00011.png)

# Types of Cloud Computing
![](./00012.png)

# Types of Cloud
![](./Types%20of%20Cloud.png)
![](./Types%20of%20Cloud1.png)
![](./00013.png)

# Budgets
⚠️Beware that some servrices also charged
They both creates a SNS(it is just a service notifier where it sends a email to notify about bills, anomilies)
* Biling console(It has forecasting)
* Cloud Watch(Billing allarms (They dont have forecasting))
Both has its special utulity


# Innovation Waves
![](./Screenshot%20from%202022-05-29%2023-10-44.png)
![](./Screenshot%20from%202022-05-29%2023-11-12.png)


# Regions & Zones

The subnet is like avability zone
Regions
+------+  
| (AZ) |
+------+
AZ = avability zone

In **EC2** we select the avability zone
In **S3** bucket we dont select the avability zone but select the region
in **Cloudfront** we are not selecting the region we are giving the geogrphic zones(like asia, north america)
in **IAM** we dont specify anything as it is global

VPC is regionaly scoped service meaning it sits across all availability zones within that region
subnets are availability zone scoped means they sit in individual avilibility zones
multiple subnets in different availbility zones in a single VPC. multiple VPCs in the same region or diff region however NO VPC can span multiple regions
VPC's can connect to each other means VPC connectoins can span multiple regions
so we have ability to peer VPC together to expand our environment if necssary

the use of route tables, network interfaces and interface endpoints gives complete control over the security configuration and connectivity of resources in our VPC

by default all incomming connections are **BLOCKED!!** & all outgoing connections are **ALLOWED!!**

to distribute traffic among a single region we need elastic load balancer(ELB)
to distrubte traffic among different regions er need Amazon Route 53

undifferenciated heavy lifting that is we manage all the physical stuff for you

a user is a permenanent identity and roles are temporary identity


# Cloud architecture
to have highly available in EC2 where every instance is one AZ so we need to have deploy EC2 with different AZs and have elastic ip where load balcned
we can instead use elaastic beanstalk

place the info here

# IAC
Cloud Formation
```yml
# Yaml for the cloudformation in s3 bucket
# template.yaml
AWSTemplateFormatVersion: "2010-09-09"
Resources:
  HelloBucket:
    Type: 'AWS::S3::Bucket'
Outputs:
    HelloBucketDomain:
        Description: The domain of the bucket
        Value: !GetAtt HelloBucket.DomainName
```
```sh
# here we are using AWS cli to create the cloudformation stack in the template
aws cloudformation create-stack \
  --stack-name myStack232 \
  --template-body file://Demo_files/template.yaml
```

cloud development Kit
it is cloudformation but we use programming language
[https://github.com/aws/aws-cdk/blob/main/README.md]()

cloud9 is a IDE in aws
![](./Screenshot%20from%202022-06-12%2009-17-17.png)
![](./Screenshot%20from%202022-06-12%2009-18-53.png)
![](./Screenshot%20from%202022-06-12%2009-19-49.png)
![](./Screenshot%20from%202022-06-12%2010-09-46.png)
![](./Screenshot%20from%202022-06-12%2010-08-51.png)
![](./Screenshot%20from%202022-06-12%2010-09-46.png)
![](./Screenshot%20from%202022-06-12%2010-09-56.png)
![](./Screenshot%20from%202022-06-12%2011-23-38.png)

# Management and deployment
access keys
![](./Screenshot%20from%202022-06-12%2011-25-34.png)
![](./Screenshot%20from%202022-06-12%2011-26-44.png)
![](./Screenshot%20from%202022-06-12%2011-44-57.png)
![](./Screenshot%20from%202022-06-12%2011-48-24.png)



# documentations

you can contribute in the docs
aws labs github
[Github Link](https://github.com/awslabs)

# responsibility
IaaS
PaaS
SaaS
FaaS

AWS CLoud trail logging events

# Edge COMPUTING
wavelength (where we create a subnet which is close to the providers with choosing zones then running EC2 instances on these VPC's or subnets)

as AWS Lambdas causes cold start so we use aws cloudfrontfunction if will have cold start but be a lot faster for the fact that its in the edge 

# STORAGE
## S3
llifecycle management where we can make a file or all inside bucket to move from one storage class to another 
MAX 10 buckets

there is a service limit page / **Service Quotoes**
it provides the service limits for each AWS resources

## EBS
For the attachnig to the EC2

## EFS
for sharing volume to multiple VMs

# Databases

# Networking

[Visualize CIDR](https://cidr.xyz/)

Security group only give options to allow not to block
Network Access (ACLs) we can allow and block

first DELETE EC2 then GATEWAY then SUBNETS then VPC then ROUTE TABLE

## CloudFront
used to take data from resource(like S3) then cache it everywhere

# EC2
IAM instancerole
SSM-role (AmazonSSMManagedInstanceCore)

## Elastic IP
to get the static IP for the Ec2 we need the elastic IP first allocate then associate with the resource

reallocate the 

## AMI create and AMI templates

## ASG(auto scaling group)

for high avability we need atleat 3 AZs

if ASG then Load balancer ✅ (must)

LB must be in same AZ's
then we need target Group for setup of ALB
then after target group and Load balancer we edit the ASG and link the target group

then copy the DNS of LB

Load balancer -> target groups -> Auto Scaling -> instance

### Cleanup
AutoScaling then load balancer & target groups

> When we are attaching 2 resources like EC2 with S3 we have to create a **IAM ROLE**

Policy to access S3 to only list the buckets
then we create a role for Ec2 where policy is mybucket
then create EC2 with no Security policy and no .PEM key
add the IAM Role during creation (AFTER creation modify the IAM to add it then restart the instance to get options)

then upload files to folder in the S3 buckets
then open the sessionManager in EC2

```json
// policy of S3
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:ListStorageLensConfigurations",
                "s3:ListAccessPointsForObjectLambda",
                "s3:GetAccessPoint",
                "s3:PutAccountPublicAccessBlock",
                "s3:GetAccountPublicAccessBlock",
                "s3:ListAllMyBuckets",
                "s3:ListAccessPoints",
                "s3:PutAccessPointPublicAccessBlock",
                "s3:ListJobs",
                "s3:PutStorageLensConfiguration",
                "s3:ListMultiRegionAccessPoints",
                "s3:CreateJob"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::my-demo-32423423/enterprise-d/*",
                "arn:aws:s3:::my-demo-32423423"
            ]
        },
        {
            "Effect": "Deny",
            "Action": "s3:GetObject",
            "Resource": [
                "arn:aws:s3:::my-demo-32423423/downloads.pdf"
            ]
        }
    ]
}
```

# Application integrating
## Simple queueing
## Streaming
Kinesis
or we could use Kafka for streaming in queue (real time)
## Pub/Sub
publish and subscribe
## API Gateway
## State macheines
## Event Bus and Amazon Event Bridge

# Governance
(CSC)Configuration vs code
## AWS config

[Conformation Pack](https://us-east-1.console.aws.amazon.com/config/home?region=us-east-1#/conformance-packs/deploy)
when the particular config is violating then there are all the ways to remediate using the **Rules** in AWS Config like notify specif people ,etc,
then there is a option to create custom rules for the config by use aws lamdas

## Quick Starts
uses the CloudFormation templates to speed up the process


## Resource Group
its in system manager or search in the resource groups
its used to group similar labels resources to as to group and filter them together
**Resource groups and tag**

its also used for **Resource Groups for IAM Policies**
basically when assigning roles to a user to a resource group and not individual resources


> AWS Amplify is for serveless web apps

# Elastic Beanstalk

# Serveless (More)
* api gateway
* app sync
* amplify
* App integration(SNS, SQS)

Should have trail AWS Trail setup in the root account in the 

# WellArchitected Tool
[AWS WellArchitected Tool](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html)
Whitepaper in AWS

# AWS Calculator

health dashboard

# Security

[Link](https://aws.amazon.com/compliance/programs/)
PII = personal identitable identy
[Link](https://aws.amazon.com/security/penetration-testing/)

[AWS Artifacts](https://us-east-1.console.aws.amazon.com/artifact/home)
