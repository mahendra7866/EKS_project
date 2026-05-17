resource "aws_eks_cluster" "main" {

  name     = "devops-assignment-eks"
  role_arn = aws_iam_role.eks_cluster.arn

  version = "1.31"

  vpc_config {

    subnet_ids = data.aws_subnets.private.ids

    security_group_ids = [
      aws_security_group.eks_cluster.id
    ]

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

resource "aws_eks_node_group" "private_nodes" {

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "private-worker-nodes"

  node_role_arn = aws_iam_role.node_group.arn

  subnet_ids = data.aws_subnets.private.ids

  instance_types = ["t3.medium"]

  capacity_type = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ecr_policy
  ]
}