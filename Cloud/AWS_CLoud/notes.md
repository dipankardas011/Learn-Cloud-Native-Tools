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


<!-- 
![](./010.png)
![](./011.png)
![](./012.png)
![](./013.png)
![](./014.png)
![](./015.png)
![](./016.png)
![](./017.png)
![](./018.png)
![](./019.png)
![](./020.png)
![](./021.png)
![](./022.png)
![](./023.png)
![](./024.png)
![](./025.png)
![](./026.png)
![](./027.png)
![](./028.png)
![](./029.png)
![](./030.png)
![](./031.png)
![](./032.png)
![](./033.png)
![](./034.png)
![](./035.png)
![](./036.png)
![](./037.png)
![](./038.png)
![](./039.png)
![](./040.png)
![](./041.png)
![](./042.png)
![](./043.png)
![](./044.png)
![](./045.png)
![](./046.png)
![](./048.png)
![](./049.png)
![](./050.png)
![](./051.png)
![](./052.png)
![](./053.png)
![](./054.png) -->

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