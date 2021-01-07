function mk-start-conf {
    if [ $# -eq 0 ]; then
        echo "Arguments, mr Nowak. I want your arguments god dammit!"
        printCmd 'minikube-start --memory=${1} --cpus=${2}'
    elif [ $# -lt 2 ]; then
        echo "You really though that'd be enough?"
        printCmd 'minikube-start --memory=${1} --cpus=${2}'
    elif [ $# -eq 2 ]; then
        if ! [ ${1} -eq ${1} ] 2>/dev/null || ! [ ${2} -eq ${2} ] 2>/dev/null; then
            echo "Integers motherfucker, do you have'em?"
            printCmd 'minikube-start --memory=${1} --cpus=${2}'
        elif [ ${2} -gt ${1} ]; then
            echo "Feeling courageous on them cpus, aren't we?"
            printCmd 'minikube-start --memory=${1} --cpus=${2}'
        else 
            local memory=${1}
            if [ ${1} -lt 7 ]; then
                memory=$((${1} * 1024))
            fi
            minikube-start --memory=$memory --cpus=${2}
        fi
    else
        echo "Something's wrong, I can feel it"
        printCmd 'minikube-start --memory=${1} --cpus=${2}'
    fi  
}

function printCmd {
    if [ $# -ne 1 ]; then
        echo "Awaiting command"
    else
        echo "Goes like this: ${1}"
    fi
}

function getPodName {
    if [ $# -eq 2 ]; then
        echo `k get pod -n ${1} | grep ${2} | awk '{ print $1 }'`
    else
        printCmd '${1}: namespace ${2}: pod name'
    fi
}

function exportPodName {
    if [ $# -eq 2 ]; then
        export ${1}=${2}
    else
        printCmd '${1}: variable ${2}: value'
    fi
}
