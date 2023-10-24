output "kubeconfig" {
  value = aws_eks_cluster.staging-env-eks-cluster.kubeconfig
}

output "master_public_ip" {
  value = aws_eks_cluster.staging-env-eks-cluster.endpoint
}

output "kubeconfig2" {
  value = aws_eks_cluster.production-env-eks-cluster.kubeconfig
}

output "master_public_ip2" {
  value = aws_eks_cluster.production-env-eks-cluster.endpoint
}

output "jenkins-dev-ip" {
  value = aws_instance.jenkins-dev.public_ip
}

output "Tomcat-dev-ip" {
  value = aws_instance.Tomcat-dev.public_ip
}
