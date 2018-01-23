FROM alpine

RUN apk add --no-cache git openssh

ENV PRIVATE_KEY ''
ENV PRIVATE_KEY_BASE64 ''

WORKDIR /app

COPY ./action.sh ./

CMD echo "use with \`./action.sh <source_repo_url> <source_branch> <target_repo_url> <target_branch>\` and provide the environment variable PRIVATE_KEY or PRIVATE_KEY_BASE64" && exit 1
