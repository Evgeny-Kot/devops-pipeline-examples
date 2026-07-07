# ArgoCD integration

Create one ArgoCD Application per environment and use a consistent name such as `example-nodejs-app-staging`. The pipeline forms this name from `ARGOCD_APP_PREFIX` and `DEPLOY_ENVIRONMENT`.

The automation token should belong to a dedicated ArgoCD account with only the permissions needed to get, sync, and wait on the named applications. Do not use an administrator token.

Example RBAC policy:

```csv
p, role:jenkins-deployer, applications, get, example-project/example-nodejs-app-*, allow
p, role:jenkins-deployer, applications, sync, example-project/example-nodejs-app-*, allow
g, jenkins-deployer, role:jenkins-deployer
```

Configure automated pruning and self-healing according to environment risk. Development may use fully automated sync. Production commonly uses a reviewed Git change plus a controlled sync window.

Jenkins calls `argocd app sync` and then `argocd app wait --sync --health --operation`. Keeping the wait separate makes it clear whether a failure occurred while accepting desired state or while Kubernetes converged to it.

