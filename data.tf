data "aws_vpc" "eks_vpc" {

  filter {
    name   = "tag:Name"
    values = ["eks-vpc"]
  }
}

data "aws_subnets" "private" {

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks_vpc.id]
  }

  tags = {
    Name = "private-*"
  }
}
data "aws_subnets" "public" {

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks_vpc.id]
  }

  tags = {
    Name = "public-*"
  }
}