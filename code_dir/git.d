function git-push {
    local currentBranch=`git branch --show-current`
    git push --set-upstream origin $currentBranch
}
