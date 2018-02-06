# bitbucket-to-heroku

Git clones a branch of a source repo and pushes it as another branch on a target repo.

Assumes that a SSH private key is provided as the environment variable `PRIVATE_KEY` or is base64 encoded as `PRIVATE_KEY_BASE64`.

Four required arguments:

    ./action.sh <source_repo_url> <source_branch_or_commit> <target_repo_url> <target_branch>

## Codeship Usage

`codeship-services.yml` example

```
heroku-deployment:
  image: bluedrop360/bitbucket-to-heroku:v1.1
  encrypted_environment:
    # ssh private key, public key provided to both bitbucket and heroku
    # echo -n "PRIVATE_KEY_BASE64=$(pbpaste | base64)" > raw.tmp && jet encrypt raw.tmp crypt.tmp && cat crypt.tmp | pbcopy && rm raw.tmp crypt.tmp
    - <encypted_value_generated_from_above>
```

`codeship-steps.yml` example

```
- name: heroku-deployment
  tag: master
  service: heroku-deployment
  command: /bin/sh -c './action.sh git@bitbucket.org:<org>/<project>.git $CI_COMMIT_ID ssh://git@heroku.com/<app-name>.git master'
```

**Note:** _The above assumes Codeship cli `jet` utility and using a Mac with the cli copy and paste utilities `pbpaste` and `pbcopy`._

## Version

### v1.1

- Added ability to specify source commit or branch
