output "cluster_name" {
  value = aws_eks_cluster.eks[0].name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks[0].endpoint
}

output "cluster_ca" {
  value = aws_eks_cluster.eks[0].certificate_authority[0].data
}

output "nodegroup_role_arn" {
  value = aws_iam_role.eks-nodegroup-role[0].arn
}
