data "terraform_remote_state" "infra_db" {
  backend = "s3"
  config = {
    bucket = "oficina-techchallenge-terraform-state-fase5-2026"
    key    = "infra-db/terraform.tfstate"
    region = "us-east-1"
  }
}

# ==========================================
# 1. KUBERNETES (EKS) E NODES
# ==========================================
resource "aws_eks_cluster" "hackathon_cluster" {
  name     = "hackathon-eks-cluster"
  role_arn = var.terraform_admin_arn
  version  = "1.30"

  vpc_config {
    subnet_ids              = data.terraform_remote_state.infra_db.outputs.public_subnet_ids
    endpoint_public_access  = true
    endpoint_private_access = false
    public_access_cidrs     = ["0.0.0.0/0"]
  }
}

resource "aws_eks_node_group" "hackathon_nodes" {
  cluster_name    = aws_eks_cluster.hackathon_cluster.name
  node_group_name = "hackathon-nodes"
  node_role_arn   = var.terraform_admin_arn
  subnet_ids      = data.terraform_remote_state.infra_db.outputs.public_subnet_ids

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [aws_eks_cluster.hackathon_cluster]
}

# ==========================================
# 2. FILA DE PROCESSAMENTO (SQS)
# ==========================================
resource "aws_sqs_queue" "video_queue" {
  name                       = "hackathon-video-queue"
  message_retention_seconds  = 86400 # 1 dia
  visibility_timeout_seconds = 300   # 5 minutos para o Worker processar o vídeo
}

# ==========================================
# 3. BUCKET DE ARMAZENAMENTO DE VÍDEOS (S3)
# ==========================================
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "videos_bucket" {
  bucket        = "fiap-hackathon-videos-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "videos_bucket_access" {
  bucket                  = aws_s3_bucket.videos_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ==========================================
# 4. REGISTRY DOCKER (ECR)
# ==========================================
resource "aws_ecr_repository" "api_repo" {
  name                 = "hackathon-api"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

resource "aws_ecr_repository" "worker_repo" {
  name                 = "hackathon-worker"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}