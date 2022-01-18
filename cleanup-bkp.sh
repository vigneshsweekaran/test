#!/bin/bash

flag_delete=false

pattern=(*\/main *\/master *\/develop \
         *OrderDesign* \
         *\/upgrade\/*)

if [[ $1 == "clean" ]]; then
  for branch in $(git branch -r |  sed 's/\*//' |  sed '/origin\/HEAD/d' | sed 's/^\s*//'); do
    # if !( [[ -f "$branch" ]] || [[ -d "$branch" ]] ) && [[ "$(git log $branch --since "1 month ago" | wc -l)" -eq 0 ]]; then
      for match in "${pattern[@]}"; do
        echo "Before IF ==${match}:${branch}=="
        if [[ $branch == $match ]]; then
          echo "Inside IF ==${match}:${branch}=="
          break
        else
          echo "Else IF ==${match}:${branch}=="
          # Reached end of pattern array, so branch name not matching the pattern, we can delete it
          if [[ $match == "${pattern[-1]}" ]]; then flag_delete=true; fi;
        fi
      done
      if [[ "$flag_delete" == "true" && "$2" == "yes" ]]; then
          echo "Inside second IF ==${match}:${branch}=="
          local_branch_name=$(echo "$branch" | sed 's/origin\///')
          echo "********** Deleting branch: $local_branch_name **********"
          git push --delete origin "${local_branch_name}"
          flag_delete=false
      elif [[ "$flag_delete" == "true" ]]; then
        echo "Inside second else ==${match}:${branch}=="
        echo "$branch"
        flag_delete=false
      fi
    # fi
  done
fi

if [[ $1 == "move" ]]; then
  for branch in $(git branch -r | sed '/origin\/HEAD/d' | sed 's/^\s*//' | grep ^origin/$2); do
    old_branch_name=$(echo "${branch}" | sed "s/origin\/$2\///")
    if [[ $4 == "yes" ]]; then
      git push origin ${branch}:refs/heads/${3}/${old_branch_name} :$2/${old_branch_name}
    else
      echo "Source branch: $branch  --> Target branch: ${3}/${old_branch_name}"
    fi
  done
fi

# Examples for move (It creates new branch and delete old branch)
# For Dry run
# ./cleanup.sh move src_folder destination_folder
# ./cleanup/sh move bug feature
# For moving
# ./cleanup/sh move bug feature yes


# for branch in $(git branch -a |  sed 's/\*//' |  sed '/origin\/HEAD/d' | sed 's/^\s*//' | sed 's/^remotes\///' | grep -v 'main$\|master$\|develop$'); do
#   if !( [[ -f "$branch" ]] || [[ -d "$branch" ]] ) && [[ "$(git log $branch --since "1 month ago" | wc -l)" -eq 0 ]]; then
#     if [[ "$ACTION" = "clean" ]]; then
#         local_branch_name=$(echo "$branch" | sed 's/origin\///')
#         echo "********** Deleting branch: $local_branch_name **********"
#         git push --delete origin "${local_branch_name}"
#     else
#       echo "$branch"
#     fi
#   fi
# done