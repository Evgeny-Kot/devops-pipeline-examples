# GitOps operating model

The GitOps repository is the deployment system of record. Jenkins builds and verifies an image, then proposes the smallest possible desired-state change: the repository and immutable tag in one environment's Helm values file. ArgoCD reconciles that commit into Kubernetes.

This separates responsibilities cleanly:

- The application repository owns source, tests, and image construction.
- The GitOps repository owns environment configuration and promotion history.
- Jenkins supplies evidence and writes an auditable deployment commit.
- ArgoCD owns Kubernetes reconciliation and drift correction.

Jenkins never runs `kubectl set image`. A direct cluster mutation would make Git stale immediately and weaken rollback. Rollback is a revert in the GitOps repository, followed by ArgoCD reconciliation.

## Repository contract

The Node.js pipeline expects this path:

```text
environments/<environment>/applications/example-nodejs-app/values.yaml
```

and updates these fields with `yq` v4:

```yaml
image:
  repository: harbor.example.com/example-platform/example-nodejs-app
  tag: abcdef123456-42
```

Protect the default branch, require reviews for production paths, disallow force-push, and grant the Jenkins deploy key write access only to the GitOps repository. For stricter production controls, have Jenkins open a pull request instead of pushing directly.

