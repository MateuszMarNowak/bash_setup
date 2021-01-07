#!/bin/bash

main(){
    local valid="^[$HOME/a-zA-Z]+$"
    if [[ ${1} =~ $valid ]]
    then
        echo ok
    else
        echo nie
    fi
}

main ${1}