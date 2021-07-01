#!/bin/bash

BRANCH=$(git rev-parse --abbrev-ref HEAD)

branchType=${BRANCH:0:4}
if [ "$branchType" == "feat" ] || [ "$branchType" == "dvbg" ] || [ "$branchType" == "esbg" ]
then
    parentBranch='main'
fi

if [[ "$branchType" == "qabg" ]]
then
    parentBranch='release/next'
fi

if [[ "$branchType" == "hfbg" ]]
then
    parentBranch='hotfix/next'
fi


if [[ "$BRANCH" != "$parentBranch" ]]
then
    git checkout $parentBranch
    git pull origin $parentBranch
    git checkout $BRANCH
    git pull origin $BRANCH
fi

echo $parentBranch
exit;

parentBranchCommitId=$(git log origin/$parentBranch --pretty=format:"%h" -1)

isExist=$(git branch --contains $parentBranchCommitId | grep $BRANCH)

if [[ "$isExist" == "" ]]
then
    echo "Invoke the rebase......"
    git rebase $parentBranch
    #git push origin $BRANCH -f
    echo "$(tput setaf 2) **************** Rebase is initiated *************************"
else
    echo "$(tput setaf 2) ************************************************
        ********** Your branch does not require rebase.   ****************************"
fi