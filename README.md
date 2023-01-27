# Atlas CLI — CI Workflow with GitHub Actions

This is a sample repository with a configured Github Actions workflow that:

- Creates a new Atlas project and an M0 cluster.
- Runs the project tests.
- Deletes the cluster and the project.

The workflow executes every time you push changes to the repository. 

## Setup

1. Generate and API key for your Atlas project with the following permissions:

- Organization Member
- Organization Project Creator

2. Add the public and private key to the GitHub secrets:

- MONGODB_ATLAS_PRIVATE_API_KEY
- MONGODB_ATLAS_PUBLIC_API_KEY

3. Locate the Atlas Organization ID and add it as a secret:

- MONGODB_ATLAS_ORG_ID

4. Set up a self-hosted GitHub runner and add its IP address to the allow list for the Atlas API key.

5. Push a change to the repo to trigger the workflow.

## Disclaimer

Use at your own risk; not a supported MongoDB product
