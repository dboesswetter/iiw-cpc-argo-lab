data "aws_eks_cluster_auth" "default" {
  name = aws_eks_cluster.default.name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}

resource "kubernetes_namespace" "argo" {
  metadata {
    name = "argo"
  }
}

provider "kubectl" {
  host                   = aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
  load_config_file       = false
}

data "http" "argo_manifest" {
  url = "https://github.com/argoproj/argo-workflows/releases/download/v3.5.7/quick-start-minimal.yaml"
}

resource "kubectl_manifest" "argo" {
  yaml_body  = data.http.argo_manifest.body
  depends_on = [kubernetes_namespace.argo]
}