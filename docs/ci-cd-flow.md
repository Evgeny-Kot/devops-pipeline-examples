# CI/CD flow and controls

## Change path

Pull requests run checkout, dependency installation, linting, tests, analysis, build, and security scanning. They do not receive deployment credentials and do not publish images. A protected `main` branch is the only source allowed to update desired state.

The Node.js pipeline creates the immutable tag `<12-character-git-sha>-<jenkins-build-number>`. The SHA connects an image to source; the build number prevents collisions when the same commit is rebuilt after a toolchain or base-image change.

## Failure boundaries

| Boundary | Behaviour |
| --- | --- |
| Dependency registry | Two attempts; persistent failures stop the build. |
| Unit test | Fails the build and publishes any available JUnit report. |
| Quality gate | Wait is limited to ten minutes and aborts on rejection. |
| Vulnerability scan | High or critical fixable findings block publication. |
| Image push | Three attempts for transient registry failures. |
| GitOps push | Three attempts; a concurrent Git change requires a new build rather than an unsafe force-push. |
| ArgoCD | Sync and health wait are bounded; Jenkins does not wait indefinitely. |
| Smoke test | Five short attempts cover ingress and endpoint convergence. |

## Operational controls

- Concurrent deployment builds are superseded to prevent older desired state racing newer state.
- Jenkins credentials are referenced by ID and masked by credential-binding steps.
- Workspaces and local images are removed in `post` actions.
- Build and artifact retention are finite.
- Production deployment remains an explicit parameter and should also be protected with Jenkins authorization or an approval policy.

