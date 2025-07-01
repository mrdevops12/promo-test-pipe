# promo-test-pipe
alb-controller.tf

Purpose: Provisions the AWS Load Balancer Controller in the EKS cluster using Helm. Includes:
IAM OIDC provider for EKS.

IAM policy and role for ALB controller.

Kubernetes service account with IAM role annotation.

Helm release for ALB controller with subnet auto-discovery

alb-iam-policy.json

Purpose: Contains the official AWS IAM policy required by the ALB controller. Used by: alb-controller.tf to attach permissions to the IAM role.


helm-prometheus.tf

Purpose: Installs the kube-prometheus-stack (Prometheus, Grafana, Alertmanager) using Helm. Includes:

Helm chart source and version

Reference to values.yaml for configuration

Deploys into demo-monitoring namespace

ingress-monitoring.tf

Purpose: Creates an ALB Ingress resource to expose Grafana and Prometheus via path-based routing. Key Features:

Uses internal ALB

Explicit subnet IDs for reliability

namespace.tf

Purpose: Creates the demo-monitoring namespace where all monitoring components are deployed.

Routes /grafana and /prometheus to respective services

providers.tf

Purpose: Configures AWS, Kubernetes, and Helm providers using EKS cluster data. Includes:

EKS cluster endpoint and auth

subnet-tags.tf

Purpose: Dynamically discovers private subnets and tags them for ALB usage. Tags Added:

kubernetes.io/role/internal-elb = 1

kubernetes.io/cluster/<cluster-name> = owned

Token-based authentication for Kubernetes and Helm

values.yaml

Purpose: Custom configuration for the Prometheus stack Helm chart. Key Settings:

Grafana, Prometheus, and Alertmanager use ClusterIP

Ingress is disabled (handled separately via ALB)

variables.tf

Purpose: Declares input variables used across the Terraform configuration. Includes:

AWS region

EKS cluster name

VPC ID

versions.tf

Purpose: Specifies required Terraform version and provider versions for compatibility.

wait-for-alb.tf

Purpose: Ensures the ALB controller pod is fully ready before applying Ingress resources. Prevents: Race conditions during terraform apply.

