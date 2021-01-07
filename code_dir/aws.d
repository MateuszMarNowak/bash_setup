function aws-mfa_createFile {
    if [ $# -eq 1 ]
    then
        if test -f ~/.aws/mfa_device 
        then
            local current_mfa=`cat ~/.aws/mfa_device`
            echo "Current mfa device arn is: $current_mfa"
        else
            echo "Creating ~/.aws/mfa_device file"
            echo ${1} > ~/.aws/mfa_device
        fi
    else
        echo "First argument: your mfa device arn"
    fi
}

function aws-mfa_getArn {
    if test -f ~/.aws/mfa_device
    then
        cat ~/.aws/mfa_device
    else
        echo "File does not exist, execute mfaAWSDevice_createFile to create it"
    fi
}

function aws-mfa_getCredentials {
    local valid='[0-9]{6}'
    if [ $# -ne 1 ] || ! [[ ${1} =~ $valid ]]
    then
        echo "Provide token ( 6 digit ) for mfa device"
    else 
        aws sts get-session-token --serial-number `aws-mfa_getArn` --token-code ${1}
    fi
}

function aws-profile_create {
    if [ $# -ne 2 ]
    then
        read -p 'Profile: ' profile
        read -p 'Region: ' region
        aws configure set --profile $profile region $region
        echo "Profile $profile created in a region $region"
    else
        aws configure set --profile ${1} region ${2}
    fi
}

function aws-mfa_refreshCredentials {
    local resp=`aws-mfa_getCredentials ${1}` 2>/dev/null
    local aws_access_key_id=`echo $resp | jq -r '.[].AccessKeyId'` || echo "Parsing failed" 
    local aws_secret_access_key=`echo $resp | jq -r '.[].SecretAccessKey'` || echo "Parsing failed" 
    local aws_session_token=`echo $resp | jq -r '.[].SessionToken'` || echo "Parsing failed" 
    aws configure set --profile mfa aws_access_key_id $aws_access_key_id || echo "Parsing failed" 
    aws configure set --profile mfa aws_secret_access_key $aws_secret_access_key || echo "Parsing failed" 
    aws configure set --profile mfa aws_session_token $aws_session_token || echo "Parsing failed"

}
