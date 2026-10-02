provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca)
  token                  = data.aws_eks_cluster_auth.eks.token
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

resource "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<YAML
- rolearn: ${module.eks.nodegroup_role_arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
- rolearn: arn:aws:iam::356458533045:role/jump-server-role
  username: jump-server-admin
  groups:
    - system:masters
YAML

    mapUsers = <<YAML
- userarn: arn:aws:iam::356458533045:user/cicd-user-demo-mern
  username: cicd-user-demo-mern
  groups:
    - system:masters
YAML
  }
}
