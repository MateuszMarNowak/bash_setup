function git-add-commit-push {
    if [ $# -eq 0 ]
    then
        read -p "Empty message, are you sure? [y]" switch
        case $switch in
                        'y')
                        ;;
                        *)
                        echo "aborted"
                        exit 0 &>/dev/null
                        ;;
        esac
    else
        git add .
        git commit -m "'$*'"
        git-push
    fi
}

function git-push {
    local currentBranch=`git branch --show-current`
    git push --set-upstream origin $currentBranch
}

function git-empty {
    if [ -z ${1} ]
    then
            message="Trigger"
    else
            message=${1}
    fi
    git commit --allow-empty -m $message && git-push
}

function git-abandon-branch {
    local currentBranch=`git branch | grep \* | awk '{print $2}'`
    echo "Are you sure, [y]es will delete $currentBranch branch, [any] to break."
    read -p "Hit key: " switch
    case $switch in
                    'y')
                    git checkout main
                    git branch -d $currentBranch
                    ;;
                    *)
                    echo "Aborted"
                    ;;
    esac
}

function git-remove-branches {
    for branch in `git branch | grep -v main`
    do
        git branch -d $branch
    done
}