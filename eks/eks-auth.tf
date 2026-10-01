
provider "kubernetes" {
  host                   = aws_eks_cluster.eks[0].endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks[0].certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks[0].name
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<YAML
- rolearn: ${aws_iam_role.eks-nodegroup-role[0].arn}
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
