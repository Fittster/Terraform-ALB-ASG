Project that creates a custom VPC with private and public subnets across two availability zones.

An ALB routes traffic to a Auto Scaling Group which creates instances in both public subnets to serve the requests.    

The EC2 instances created in the private subnet dont have a practical purpose
