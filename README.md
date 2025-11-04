# PoC OCM Bill of Behavior

A proof of concept implementation demonstrating [Open Component Model](http://ocm.software) (OCM) integration with security-focused Kubernetes deployments, featuring a comprehensive "[Bill of Behavior](https://github.com/k8sstormcenter/bob)" approach to software supply chain security.

## Project Overview

This repository implements a complete OCM-based software delivery pipeline that extends beyond traditional Software Bill of Materials (SBOM) to include runtime behavior monitoring and security policy enforcement. The project demonstrates how OCM can be used to package, deliver, and manage cloud-native applications with integrated security scanning and behavior analysis.

### Architecture

The solution consists of multiple OCM components orchestrated through GitOps principles:

- **Root Component** (`bob.poc.ocm.software/root`): Main orchestration component containing Landscaper blueprints
- **Web Application** (`bob.poc.ocm.software/webapp`): Sample containerized web application 
- **Security Components**: Kubescape for security scanning and OpenEBS for secure storage
- **Runtime Rules**: Custom security policies and behavior monitoring

### Key Technologies

- **[Open Component Model](http://ocm.software) (OCM)**: Component-based software delivery and lifecycle management
- **[Kubescape](http://kubescape.io)**: Kubernetes security platform for compliance and vulnerability scanning
- **[OpenEBS](https://openebs.io/)**: Container-native storage for stateful workloads
- **[Flux](http://fluxcd.io)**: GitOps continuous delivery for Kubernetes
- **[Helm](http://helm.sh)**: Package management for Kubernetes applications

## Repository Structure

```
poc-ocm-bill-of-behavior/
├── README.md                           # This documentation
├── Makefile                           # Build and OCM packaging automation
├── renovate.json                      # Automated dependency updates
├── .gitignore                         # Git ignore patterns
│
├── ocm/                               # OCM component definitions
│   ├── bob-poc-root/                  # Root orchestration component
│   ├── bob-poc-webapp/                # Sample web application component
│   ├── bob-poc-kubescape/            # Security scanning component
│   ├── bob-poc-kubescape-ruleset/    # Runtime security rules
│   └── bob-poc-openebs/              # Storage component
│
├── helm/                              # Helm charts
│   └── chart/
│       ├── mywebapp/                  # Web application chart
│       ├── kubescape-ruleset/         # Security rules chart
│       └── openebs/                   # Storage configuration chart
│
└── k8s/                               # Kubernetes configurations
    ├── flux/                          # GitOps configuration
    │   ├── git-repository.yaml        # Flux source repository
    │   └── kustomization.yaml         # Flux deployment automation
    └── ocm-k8s-toolkit/              # OCM Kubernetes integration
        ├── bootstrap.yaml             # OCM component bootstrap
        └── kro-instance.yaml          # Kubernetes resource orchestration
```

## Bill of Behavior Concept

This project extends the traditional Software Bill of Materials (SBOM) concept to include a "Bill of Behavior" - comprehensive monitoring and enforcement of runtime security policies and behavioral patterns.

### Components of the Bill of Behavior

1. **Software Composition Analysis**: Traditional SBOM tracking all software components and dependencies
2. **Security Policy Enforcement**: Kubescape-based compliance checking against security frameworks
3. **Runtime Behavior Monitoring**: Continuous monitoring of application behavior against expected patterns
4. **Supply Chain Security**: OCM-based verification of component integrity and provenance

## Prerequisites

### Required Tools
- [OCM CLI](https://ocm.software/docs/getting-started/installation/) (latest version)
- [kubectl](https://kubernetes.io/docs/reference/kubectl/) for Kubernetes management
- [Helm](https://helm.sh/) for package management
- [Flux CLI](https://fluxcd.io/flux/installation/) for GitOps operations

### Infrastructure Requirements
- Kubernetes cluster (v1.24+)
- Container registry access (configured in [`OCM_REGISTRY`](./Makefile))
- GitOps repository access
- Storage provisioner (if running `kind` cluster!)

## Quick Start

### 1. OCM Component Packaging & Transporting

Package & Transport all OCM components for deployment:

```bash
# Package all component constructors
make ocm-package
# Transfer all packaged components
make ocm-transfer
```

### 2. Deploy Core Infrastructure

Install Flux
```bash
flux install
```

Apply Flux GitOps configuration:

```bash
# Deploy Flux source repository
kubectl apply -f k8s/flux/git-repository.yaml

# Deploy Flux kustomization
kubectl apply -f k8s/flux/kustomization.yaml
```

### 3. Bootstrap OCM Integration

Deploy OCM Kubernetes toolkit:

```bash
# Apply OCM bootstrap configuration
kubectl apply -f k8s/ocm-k8s-toolkit/bootstrap.yaml

# Apply resource orchestration
kubectl apply -f k8s/ocm-k8s-toolkit/kro-instance.yaml
```

## Component Details

### Root Component (`bob.poc.ocm.software/root`)

The root component serves as the main orchestrator, containing:
- Landscaper blueprints for deployment automation
- Component references to all sub-components
- Cross-component dependency management

### Web Application Component (`bob.poc.ocm.software/webapp`)

Sample web application demonstrating:
- OCM-packaged container images
- Helm chart integration
- Security policy compliance
- Runtime behavior monitoring

**Resources:**
- Helm Chart: Application deployment configuration
- Container Image: `ghcr.io/k8sstormcenter/webapp@sha256:e323014ec9befb76bc551f8cc3bf158120150e2e277bae11844c2da6c56c0a2b`

### Security Components

#### Kubescape Integration (`bob.poc.ocm.software/kubescape`)

Comprehensive Kubernetes security scanning including:
- **Operator**: `quay.io/kubescape/operator:v0.2.97`
- **Storage**: `quay.io/kubescape/storage:v0.0.206` 
- **Vulnerability Scanner**: `quay.io/kubescape/kubevuln:v0.3.82`
- **Core Scanner**: `quay.io/kubescape/kubescape:v3.0.37`

#### Runtime Security Rules (`bob.poc.ocm.software/kubescape-ruleset`)

Custom security policies and runtime rules for:
- Container behavior monitoring
- Network policy enforcement
- Resource usage compliance
- Security baseline validation

### Storage Component (`bob.poc.ocm.software/openebs`)

Container-native storage solution providing:
- Local persistent volumes
- Dynamic provisioning
- High availability storage
- Performance optimization

**Key Images:**
- Node Disk Operator: `docker.io/openebs/node-disk-operator:2.1.0`
- LocalPV Provisioner: `docker.io/openebs/provisioner-localpv:3.5.0`
- Disk Exporter: `docker.io/openebs/node-disk-exporter:2.1.0`

## Configuration

### OCM Registry Configuration

Set your OCM registry in the Makefile:

```makefile
REGISTRY ?= your-registry.example.com/ocm
```

### Flux Configuration

Update the Git repository source in `k8s/flux/git-repository.yaml`:

```yaml
spec:
  url: https://github.com/your-org/your-repo.git
  secretRef:
    name: github-pull-secret  # Configure as needed
```

### Component Versions

Component versions are automatically derived from Git tags using the pattern:
- Raw version: `git describe --tags --always --dirty --match 'ocm-*'`
- Processed version: Removes `ocm-` prefix for OCM compatibility

## Development Workflow

### Adding New Components

1. Create component directory in `ocm/`
2. Define `component-constructor.yaml` with resources and references
3. Create corresponding Helm charts if needed
4. Update root component references
5. Package using `make ocm-package`
6. Transfer using `make ocm-transfer`

### Security Policy Updates

1. Modify rules in `helm/chart/kubescape-ruleset/`
2. Update component version in `ocm/bob-poc-kubescape-ruleset/`
3. Redeploy through GitOps pipeline

### Testing Changes

```bash
# Test Helm charts
helm lint helm/chart/*/

# Verify deployment
kubectl get all -n default
```

## Security Considerations

### Supply Chain Security
- All components signed and verified through OCM
- Container image integrity checked via SHA256 digests
- Dependency tracking and vulnerability scanning

### Runtime Security
- Kubescape continuous compliance monitoring
- Network policy enforcement
- Resource usage monitoring and alerting
- Behavioral analysis and anomaly detection

### Access Control
- RBAC policies for component deployment
- Service account isolation
- Secret management through external systems

## Monitoring and Observability

### Component Health
- OCM component status monitoring
- Deployment success/failure tracking
- Resource utilization metrics

### Security Metrics
- Compliance score tracking
- Vulnerability detection and remediation
- Policy violation alerts
- Behavioral anomaly detection

## Troubleshooting

### Common Issues

**Deployment Issues:**
```bash
# Check Flux status
flux get sources git
flux get kustomizations

# Verify OCM components status
kubectl get components
kubectl get resources
```

## Contributing

### Development Setup
1. Fork the repository
2. Install required tools (OCM CLI, kubectl, Helm)
3. Make changes following existing patterns
4. Test
5. Submit pull request

### Code Standards
- Follow OCM component specification
- Use semantic versioning for components
- Include comprehensive documentation
- Test all changes in your environment (e.g. `kind` cluster)

## Resources

### Documentation
- [OCM Specification](https://ocm.software/docs/overview/specification/)
- [Kubescape Documentation](https://kubescape.io/docs/)
- [OpenEBS Documentation](https://openebs.io/docs/)
- [Flux Documentation](https://fluxcd.io/docs/)

### Related Projects
- [OCM Project](https://github.com/open-component-model)
- [Kubescape](https://github.com/kubescape/kubescape)
- [OpenEBS](https://github.com/openebs/openebs)

## License

This project is licensed under the Apache License 2.0 - see the LICENSE file for details.
