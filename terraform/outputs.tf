output "eks_cluster_name" {
  value = aws_eks_cluster.hackathon_cluster.name
}

output "sqs_video_queue_url" {
  value = aws_sqs_queue.video_queue.url
}

output "s3_videos_bucket_name" {
  value = aws_s3_bucket.videos_bucket.id
}

output "ecr_api_url" {
  value = aws_ecr_repository.api_repo.repository_url
}

output "ecr_worker_url" {
  value = aws_ecr_repository.worker_repo.repository_url
}