#!/usr/bin/env bash
set -e

require_clean_work_tree () {
    # Update the index
    git update-index -q --ignore-submodules --refresh
    err=0

    # Disallow unstaged changes in the working tree
    if ! git diff-files --quiet --ignore-submodules --
    then
        echo >&2 "cannot $1: you have unstaged changes."
        git diff-files --name-status -r --ignore-submodules -- >&2
        err=1
    fi

    # Disallow uncommitted changes in the index
    if ! git diff-index --cached --quiet HEAD --ignore-submodules --
    then
        echo >&2 "cannot $1: your index contains uncommitted changes."
        git diff-index --cached --name-status -r --ignore-submodules HEAD -- >&2
        err=1
    fi

    if [ $err = 1 ]
    then
        echo >&2 "Please commit or stash them."
        exit 1
    fi
}

require_clean_work_tree

NAME=$(cat package.json | jq .name -r | sed -e 's/@gnom1gnom\///g')

docker pull node:latest

suffix=$(git rev-parse --short HEAD)

latestTag="gnom1gnom/${NAME}:latest"
tag="gnom1gnom/${NAME}:${suffix}"

echo "Building and pushing ${tag}"

docker build -t ${tag} -t ${latestTag} .
docker push ${tag}
docker push ${latestTag}
