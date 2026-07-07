# Jenkins shared library extraction

Once several services use these pipelines, move repeated mechanics into a versioned shared library while leaving policy and service-specific values visible in each Jenkinsfile.

```text
(root)
├── resources/
├── src/com/example/pipeline/
│   ├── ContainerImage.groovy
│   └── GitOpsChange.groovy
└── vars/
    ├── nodeGitOpsPipeline.groovy
    └── notifyBuild.groovy
```

Pin the library to a release or protected branch in Jenkins global configuration:

```groovy
@Library('platform-pipeline-library@v2') _

nodeGitOpsPipeline(
    application: 'example-nodejs-app',
    harborProject: 'example-platform',
    gitopsValuesPath: 'applications/example-nodejs-app/values.yaml'
)
```

Keep credential IDs, quality thresholds, retry policy, and approved registries in typed configuration. Never pass secret values into library arguments. Test global variables with Jenkins Pipeline Unit and run a representative integration job before releasing a new major version.

The library should own stable implementation details such as notifications, image metadata, and Git commits. Repository Jenkinsfiles should continue to expose deployment intent, environment selection, and exceptional controls such as production approval.
