# ☁️ Hackathon Fase 5 - Infra K8s e Mensageria (Repo 2 de 5)

Este repositório provisiona o "palco" principal da nossa arquitetura de processamento de vídeos. Ele integra o estado remoto gerado pelo Repositório 1 (VPC) para subir um cluster Kubernetes (EKS) e cria a infraestrutura de mensageria assíncrona.

## 🎯 Responsabilidades
- Provisionar o **Amazon EKS (Kubernetes 1.30)** com nós nas subnets públicas.
- Criar a Fila **Amazon SQS** (`hackathon-video-queue`) que atuará como "buffer" de requisições, evitando perdas em momentos de picos.
- Criar o Bucket **Amazon S3** (`fiap-hackathon-videos-*`) bloqueado para o público, utilizado para salvar o `.mp4` original e o `.zip` final.
- Provisionar os Repositórios **Amazon ECR** para hospedar as imagens Docker da API e do Worker.

## 🚀 Como Executar
1. Cadastre os Secrets no GitHub: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`, `TERRAFORM_ADMIN_ARN` (A sua LabRole do Learner Lab).
2. Vá na aba Actions e rode o Workflow **🚀 Deploy Infra K8s**.
3. Aguarde cerca de 12 minutos para a conclusão do Cluster EKS.
4. Anote os valores exibidos nos **Outputs** do Terraform: URLs do ECR, nome do Bucket S3 e URL da fila SQS. Serão necessários nos próximos repositórios.