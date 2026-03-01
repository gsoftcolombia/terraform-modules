# Terraform Modules

> [!IMPORTANT]
> Each Terraform Module includes its own documentation please go directly there.

# Release Strategy

We use long-lived release branches to manage breaking changes independently:
- `release/v1.x` - All v1.x minor releases
- `release/v2.x` - All v2.x minor releases
- etc.

Each branch has its own maintenance lifecycle and deprecation timeline.

## How to Contribute Changes

1. Identify which major version branch your changes target (e.g., `release/v1.x`)
2. Create a feature branch from that release branch
3. Open a Pull Request against the release branch
4. After approval and merge, the change is ready for release

## How to Release

1. Update `CHANGELOG.md` with merged changes
2. Commit: `git commit -am "Release v1.1.0"`
3. Tag: `git tag v1.1.0` (created on the release branch)
4. Push: `git push origin release/v1.x && git push origin v1.1.0`
5. GitHub Actions automatically creates the release with CHANGELOG.md as release notes

## Branch Management and Development Process

- The files you find outside of the modules folder are corresponding to the development environment, those terraform files can be applied by running the terraform-apply workflow into the sandbox account for further tests.
- All feature work → PR → release branch → tag
- Never work directly on release branches
- Each release branch is independently maintained

# Current Limitations & Future Work

- The infra repo needs to define a `power-access-ecs-tasks` as policy and it is too wide.
- There are unmanaged dependencies between `local.github_repositories` and `local.ecr_repositories`
- The infra repo needs to create a global security group for schedule tasks.