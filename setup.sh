#!/bin/bash

askMode() {
    read -p "Do you wish to run [t]est mode or [n]ormal mode?" mode
    case $mode in 
            "t")
                script_path="$HOME/test/"
                mkdir $script_path
                ;;
            "n")
                script_path="$HOME/"
                ;;
            *)
                exit 1
    esac
    
    echo $script_path
}

catchError() {
    local valid="^[~/a-zA-Z]+$"
    if [[ "${1}" == '0' ]]
    then
        :
    elif [[ ${1} =~ $valid ]]
    then
        :
    elif [[ "${1}" == '1' ]]
    then
        echo "Last function returned error: ${1}, aborting"
        exit 1
    else
        echo "Last function returned unknown error: ${1}, aborting"
        exit 1
    fi
}

createConfFiles() {
    if test -e ${1}.bash_profile
    then
        echo "istnieje"
        cat conf_dir/bash_profile > ${1}.bash_profile
    else
        echo "nie istnieje"
        cp conf_dir/bash_profile ${1}.bash_profile
    fi

    if test -e ${1}.bashrc
    then
        cat conf_dir/bashrc > ${1}.bashrc
    else
        cp conf_dir/bashrc ${1}.bashrc
    fi
}

copyCodeFiles() {
    if ! test -d ${1}.bashrc.d
    then
        mkdir -p ${1}.bashrc.d
        for file in code_dir/*.d
        do
            cp $file ${1}.bashrc.d/
        done
    else
        for file in code_dir/*.d
        do
            cp $file ${1}.bashrc.d/
        done        
    fi
}

main() {
    local script_path=`askMode`
    echo $script_path
    catchError $script_path
    echo "Mode"

    createConfFiles $script_path
    catchError $?
    echo "conffiles"

    copyCodeFiles $script_path
    catchError $?
    echo "copy code files"
}

main

read -rsn1 -p "To apply new configuration you have to reopen terminal. Press any key to continue"
exit 0
