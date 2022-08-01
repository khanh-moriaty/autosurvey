get_data() {
    hidden_key=($(grep hidden output.txt | sed -E "s,.*name=.([^'\"]*).*,\"\1\","))
    hidden_value=($(grep hidden output.txt | sed -E "s,.*value=.([^'\"]*).*,\"\1\","))
    len_hidden_key=${#hidden_key[@]}
    len_hidden_value=${#hidden_value[@]}
    
    if [ $len_hidden_key -ne $len_hidden_value ]; then
        echo Error when getting hidden field
        exit 1
    fi

    out=()
    for (( i=0; i<len_hidden_key; i++ )); do
        temp_key="${hidden_key[$i]%\"}"
        temp_key="${temp_key#\"}"
        temp_value="${hidden_value[$i]%\"}"
        temp_value="${temp_value#\"}"
        out+="$temp_key=$temp_value&"
    done
}

for url in $(cat survey.txt); do
    sid=$(printf $url | sed -E "s,.*/sid/([^/]*)/.*,\1,")
    token=$(printf $url | sed -E "s,.*/token/([^/]*)/.*,\1,")

    # Get cookies and welcome page
    wget -q -O output.txt --save-cookies=cookies.txt --keep-session-cookies $url
    get_data

    survey_url="https://survey.uit.edu.vn/index.php/survey/index"

    # Get classroom page
    curl -k -Ss -b cookies.txt -H "Content-Type: application/x-www-form-urlencoded" --data "$out&move2=Ti%E1%BA%BFp+theo" $survey_url >output.txt
    get_data

    # Print logs
    cat output.txt | grep "td.survey-description" | sed -E "s/.*'(Khảo sát.*)'.*/\1/" | sed -e "s/<br>/\n/g"

    # Get first page
    curl -k -Ss -b cookies.txt -H "Content-Type: application/x-www-form-urlencoded" --data "$out&move2=Ti%E1%BA%BFp+theo" $survey_url >output.txt
    get_data

    # Submit first page
    temp_ans="${hidden_value[0]%\"}"
    temp_ans="${temp_ans#\"}"
    list_ans=($(echo $temp_ans | tr '|' "\n"))
    for ans in ${list_ans[@]}; do
        out+="$ans=A5&"
    done
    curl -k -Ss -b cookies.txt -H "Content-Type: application/x-www-form-urlencoded" \
        -d "$out&move=movenext" $survey_url >output.txt
    get_data

    # Submit second page
    temp_ans="${hidden_value[0]%\"}"
    temp_ans="${temp_ans#\"}"
    list_ans=($(echo $temp_ans | tr '|' "\n"))
    for ans in ${list_ans[@]}; do
        out+="$ans=MH04&"
    done
    curl -k -Ss -b cookies.txt -H "Content-Type: application/x-www-form-urlencoded" \
        -d "$out&move=movenext" $survey_url >output.txt
    get_data

    # Submit last page
    temp_ans="${hidden_value[0]%\"}"
    temp_ans="${temp_ans#\"}"
    list_ans=($(echo $temp_ans | tr '|' "\n"))
    for ans in ${list_ans[@]}; do
        out+="$ans="
    done
    curl -k -Ss -b cookies.txt -H "Content-Type: application/x-www-form-urlencoded" \
        -d "$out&move=movesubmit" $survey_url >output.txt
    get_data

done