#!/bin/bash

USERNAME="ogind-rshinde"

branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')
#echo "current branch is : $branch"

echo "$(tput setaf 2) Which type of branch you want to create?: 
1 - feature branch
2 - Dev bug branch
3 - QA bug branch
4 - hotfixes bug branch"

while :; do
  read -p "Choose the number :: " branchOption
  [[ $branchOption =~ ^[0-9]+$ ]] || { echo "Enter a valid number"; continue; }
  if ((branchOption >= 1 && branchOption <= 4)); then
    break
  else
    echo "$(tput setaf 1) ******* number out of range, try again"
  fi
done

read -p "Please enter jira ticket : "  ticket

while :; do
  read -p "$(tput setaf 2)Please enter branch description : "  description
  if (("${#description}" >= 1 && "${#description}" < 21)); then
    break
  else
    echo "$(tput setaf 1) ********* Please enter the description less than 20 characters!!!"
  fi
done

description=${description// /-}
echo "$(tput setaf 3) "

if test "$branchOption" = 1; then
    git checkout main
    git pull origin main
    git checkout -b "feat-"$ticket"/"$USERNAME"/"${description,,}
fi

if test "$branchOption" = 2; then
    git checkout main
    git pull origin main
    git checkout -b "dvbg-"$ticket"/"$USERNAME"/"${description,,}
fi

if test "$branchOption" = 3; then
    git checkout release/next
    git pull origin release/next  
    git checkout main
    git pull origin main      
    git checkout -b "qabg-"$ticket"/"$USERNAME"/"${description,,}
    git reset --hard release/next    
fi

if test "$branchOption" = 4; then
    git checkout hotfix/next
    git pull origin hotfix/next 
    git checkout -b "hfbg-"$ticket"/"$USERNAME"/"${description,,}
fi

echo "$(tput setaf 2) ********************** Branch is created successfully ****************************"