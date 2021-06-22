function git-format-add {
	for file in `git status | grep -E \*.tf | awk '{print $2}'`
	do
		terraform fmt $file
	done
	git add .
	git status
}

function git-push {
	if ! git push ; then
		local currentBranch=`git branch | grep \* | awk '{print $2}'`
		git push --set-upstream origin $currentBranch
	fi
}

function git-add-commit-push {
	if [ "$#" -lt 1 ]
	then
		echo "Empty message"
		exit 1
	else
		message='$@'
	fi

	git add .
	git status
	git commit -m $message

	function git-push {
		if ! git push ; then
			local currentBranch=`git branch | grep \* | awk '{print $2}'`
			git push --set-upstream origin $currentBranch
		fi
	}

	git-push
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
	if [ "$#" -eq 1 ]
	then
		toGoBranch=$1
	else
		toGoBranch="master"
	fi
	local currentBranch=`git branch | grep \* | awk '{print $2}'`
	echo "Are you sure, [y]es will delete $currentBranch branch, [any] to break."
	read -p "Hit key: " switch
	case $switch in 
				'y')
				git checkout $toGoBranch
				git branch -D $currentBranch
				;;
				*)
				echo "Aborted"
				;;
	esac
}
