#!/bin/sh

#Thanks @WTFox for this script


DIR=$(dirname "$0")


echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

if [[ $(git status -s) ]]
then
    echo "Adding and committing everything in develop branch"
    git add . && git commit -m "`date`"
    git push origin develop 
fi

echo "Checking out master branch into public"
git worktree add -B master public origin/master

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo

echo "Updating master branch"
cd public && git add --all && git commit -m "Publishing to github (deploy.sh)"

echo "Pushing changes"
git push origin master -f
