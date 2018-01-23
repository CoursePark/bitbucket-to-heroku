# bitbucket-to-heroku

Git clones a branch of a source repo and pushes it as another branch on a target repo.

Assumes that a SSH private key is provided as the environment variable `PRIVATE_KEY` or is base64 encoded as `PRIVATE_KEY_BASE64`.

Four required arguments:

    ./action.sh <source_repo_url> <source_branch> <target_repo_url> <target_branch>
