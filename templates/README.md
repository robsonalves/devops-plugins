# DevOps Templates

Production-ready templates to kickstart your infrastructure and deployment projects.

## Available Templates

### [Terraform Module](./terraform-module/)
Complete Terraform module template with best practices.

**Includes:**
- `main.tf` - Main resource definitions
- `variables.tf` - Input variables with validation
- `outputs.tf` - Output values
- `versions.tf` - Provider version constraints
- `README.md` - Module documentation

**Use cases:**
- Creating reusable Terraform modules
- Starting new infrastructure projects
- Establishing module standards

**Quick start:**
```bash
cp -r templates/terraform-module my-new-module
cd my-new-module
# Edit files for your resources
/tf-validate
```

### [Kubernetes Deployment](./k8s-deployment/)
Production-ready Kubernetes deployment manifests.

**Includes:**
- `deployment.yaml` - Application deployment with best practices
- `service.yaml` - ClusterIP and headless services
- `configmap.yaml` - Application configuration
- `secret.yaml` - Sensitive data management
- `ingress.yaml` - External access with TLS
- `hpa.yaml` - Horizontal Pod Autoscaler
- `README.md` - Deployment guide

**Features:**
- Health checks (liveness & readiness)
- Resource limits and requests
- Security contexts
- Pod anti-affinity for HA
- Horizontal autoscaling
- TLS/HTTPS support

**Quick start:**
```bash
cp -r templates/k8s-deployment my-app-k8s
cd my-app-k8s
# Customize for your application
/k8s-apply
```

### [Azure DevOps Pipeline](./azure-pipeline/)
Complete CI/CD pipeline for Azure DevOps.

**Includes:**
- `azure-pipelines.yaml` - Multi-stage pipeline
- `README.md` - Setup and customization guide

**Pipeline stages:**
- Build and test with caching
- Docker image build and push
- Deploy to development
- Deploy to production

**Features:**
- Test result publishing
- Code coverage reports
- Docker security scanning
- Environment-based deployment
- Kubernetes integration

**Quick start:**
```bash
cp templates/azure-pipeline/azure-pipelines.yaml .
# Customize variables and service connections
/pipeline-validate
```

### [CloudFormation Stack](./cloudformation-stack/)
AWS VPC infrastructure with CloudFormation.

**Includes:**
- `vpc-stack.yaml` - Complete VPC setup
- `README.md` - Deployment guide

**Creates:**
- VPC with configurable CIDR
- 2 Public subnets (multi-AZ)
- 2 Private subnets (multi-AZ)
- Internet Gateway
- 2 NAT Gateways (HA)
- Route tables
- Exports for other stacks

**Quick start:**
```bash
cp -r templates/cloudformation-stack my-vpc
cd my-vpc
# Customize parameters
/cfn-validate
/cfn-deploy
```

## Usage

### 1. Choose a Template

Pick the template that matches your needs.

### 2. Copy to Your Project

```bash
# Copy specific template
cp -r templates/terraform-module my-project/infrastructure

# Or copy multiple
cp -r templates/terraform-module my-project/terraform
cp -r templates/k8s-deployment my-project/k8s
```

### 3. Customize

Edit the files to match your requirements:
- Update names and labels
- Adjust resource configurations
- Set environment-specific values
- Add or remove resources

### 4. Validate

Use DevOps Toolkit commands:

```bash
# Terraform
/tf-validate

# Kubernetes
/k8s-apply  # with dry-run

# CloudFormation
/cfn-validate

# Azure Pipeline
/pipeline-validate
```

### 5. Deploy

```bash
# Terraform
/tf-plan
/tf-apply

# Kubernetes
/k8s-apply

# CloudFormation
/cfn-deploy

# Azure Pipeline
git push  # triggers pipeline
```

## Template Combinations

### Complete Application Stack

```bash
project/
├── terraform/          # From terraform-module template
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── k8s/               # From k8s-deployment template
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── cloudformation/    # From cloudformation-stack template
│   └── vpc-stack.yaml
└── azure-pipelines.yaml  # From azure-pipeline template
```

### Workflow Example

```bash
# 1. Create VPC with CloudFormation
cd cloudformation
/cfn-deploy

# 2. Deploy application infrastructure with Terraform
cd ../terraform
/tf-apply

# 3. Set up CI/CD pipeline
cd ..
/pipeline-validate
git add azure-pipelines.yaml
/commit-feat

# 4. Deploy application to Kubernetes
cd k8s
/k8s-apply
```

## Customization Guide

### Terraform Module

```hcl
# Update for your resources
resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  # Add your configuration
}
```

### Kubernetes Manifests

```yaml
# Update image and replicas
spec:
  replicas: 5  # Your replica count
  template:
    spec:
      containers:
      - name: myapp
        image: your-registry/your-app:tag
```

### Azure Pipeline

```yaml
# Update variables
variables:
  dockerRegistry: 'your-registry.azurecr.io'
  imageName: 'your-app'
  k8sNamespace: 'your-namespace'
```

### CloudFormation

```yaml
# Update parameters
Parameters:
  VpcCIDR:
    Default: 172.16.0.0/16  # Your CIDR
```

## Best Practices

### General
1. **Version control**: Always commit templates to git
2. **Environment separation**: Use different values per environment
3. **Documentation**: Update READMEs for your specific setup
4. **Validation**: Test in dev before production
5. **Security**: Don't commit secrets, use secure secret management

### Terraform
1. Use remote state (S3 + DynamoDB)
2. Enable state locking
3. Use workspaces for environments
4. Pin provider versions

### Kubernetes
1. Use namespaces for isolation
2. Set resource limits
3. Implement health checks
4. Use secrets for sensitive data
5. Enable RBAC

### CloudFormation
1. Use parameters for flexibility
2. Export outputs for other stacks
3. Enable termination protection
4. Use change sets for updates
5. Implement stack policies

### Azure Pipelines
1. Use service connections
2. Implement approval gates
3. Cache dependencies
4. Run security scans
5. Set up notifications

## Maintenance

### Updating Templates

As you improve your templates:

1. **Extract common patterns** into reusable components
2. **Document lessons learned** in READMEs
3. **Share improvements** with the team
4. **Keep templates updated** with latest best practices

### Template Versioning

Consider versioning your templates:

```
templates/
├── terraform-module/
│   ├── v1/
│   ├── v2/
│   └── current -> v2
```

## Getting Help

- **Examples**: See [examples/](../examples/) directory
- **Commands**: See main [README.md](../README.md)
- **Issues**: Open an issue on GitHub
- **Discussions**: Start a discussion for questions

## Contributing

Have improvements or new templates?

1. Create template in `templates/new-template/`
2. Include comprehensive README
3. Add to this index
4. Test thoroughly
5. Submit pull request

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

## Template Roadmap

Future templates planned:

- [ ] Docker Compose setup
- [ ] Helm chart template
- [ ] GitHub Actions workflow
- [ ] Ansible playbook
- [ ] Monitoring stack (Prometheus/Grafana)
- [ ] ArgoCD application
- [ ] Vault configuration
- [ ] Nginx configuration

## Additional Resources

- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [Kubernetes Production Best Practices](https://learnk8s.io/production-best-practices)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Azure DevOps Best Practices](https://docs.microsoft.com/en-us/azure/devops/pipelines/best-practices)

## License

MIT
