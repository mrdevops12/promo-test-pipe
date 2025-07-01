variable "aws_region" {
  default = "us-east-1"
}

variable "eks_cluster_name" {
  default = "test-kube"
}

variable "vpc_id" {
  description = "VPC ID where EKS is deployed"
  type        = string
}

