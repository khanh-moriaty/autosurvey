get_data() {
    lempostkey=$(grep LEMpostKey output.txt | sed -E "s,.*value='([^']*)'.*,\1,")
    lastgroupname=$(grep lastgroupname output.txt | sed -E "s,.*value='([^']*)'.*,\1,")
    thisstep=$(grep thisstep output.txt | sed -E "s,.*value='([^']*)'.*,\1,")
    start_time=$(grep start_time output.txt | sed -E "s,.*value='([^']*)'.*,\1,")
    lastgroup=$(grep lastgroup output.txt | sed -E "s,.*value='([^']*)'.*,\1,")
}

for url in $(cat survey.txt); do
    sid=$(printf $url | sed -E "s,.*/sid/([^/]*)/.*,\1,")
    token=$(printf $url | sed -E "s,.*/token/([^/]*)/.*,\1,")

    # Get cookies and welcome page
    wget -q -O output.txt --save-cookies=cookies.txt --keep-session-cookies $url
    get_data

    survey_url="https://survey.uit.edu.vn/index.php/survey/index"

    # Get classroom page
    curl -k -Ss -b cookies.txt -H "Content-Type: application/x-www-form-urlencoded" --data "move=movenext&move2=Ti%E1%BA%BFp+theo\
    &sid=$sid&token=$token&lastgroupname=$lastgroupname&LEMpostKey=$lempostkey&thisstep=$thisstep" $survey_url >output.txt
    get_data

    # Print logs
    cat output.txt | grep "td.survey-description" | sed -E "s/.*'(Khảo sát.*)'.*/\1/" | sed -e "s/<br>/\n/g"

    # Get first page
    curl -k -Ss -b cookies.txt -H "Content-Type: application/x-www-form-urlencoded" --data "move=movenext&move2=Ti%E1%BA%BFp+theo\
    &sid=$sid&token=$token&lastgroupname=$lastgroupname&LEMpostKey=$lempostkey&thisstep=$thisstep" $survey_url >output.txt
    get_data

    # Submit first page
    # # 2021
    # curl -Ss -b cookies.txt -H "Content-Type: application/x-www-form-urlencoded" \
    #     -d "fieldnames=269653X1356X20880%7C269653X1356X20921%7C269653X1356X20922%7C269653X1356X20923\
    # %7C269653X1356X20924A1%7C269653X1356X20924A2%7C269653X1356X20924A3%7C269653X1356X20924other\
    # &269653X1356X20880=A3&java269653X1356X20880=A3&269653X1356X20921=A1&java269653X1356X20921=A1\
    # &269653X1356X20922=A1&java269653X1356X20922=A1&269653X1356X20923=Y&java269653X1356X20923=Y\
    # &MULTI269653X1356X20924=4&java269653X1356X20924A1=&java269653X1356X20924A2=&java269653X1356X20924A3=\
    # &269653X1356X20924other=&java269653X1356X20924other=&lastgroup=$lastgroup&relevance20874=1&relevance20880=1\
    # &relevance20884=1&relevance20921=1&relevance20922=1&relevance20923=1&relevance20924=0&relevanceG1=1\
    # &move=movenext&thisstep=$thisstep&sid=$sid&start_time=$start_time&LEMpostKey=$lempostkey&token=$token" $survey_url >output.txt
    # 2022
    curl -k -Ss -b cookies.txt -H "Content-Type: application/x-www-form-urlencoded" \

        -d "fieldnames=934395X1370X21458%7C934395X1370X21463%7C934395X1370X21464%7C934395X1370X21465\
    %7C934395X1370X21466A1%7C934395X1370X21466A2%7C934395X1370X21466A3%7C934395X1370X21466other\
    &934395X1370X21458=A3&java934395X1370X21458=A3&934395X1370X21463=A1&java934395X1370X21463=A1\
    &934395X1370X21464=A1&java934395X1370X21464=A1&934395X1370X21465=Y&java934395X1370X21465=Y\
    &MULTI934395X1370X21466=4&java934395X1370X21466A1=&java934395X1370X21466A2=&java934395X1370X21466A3=\
    &934395X1370X21466other=&java934395X1370X21466other=&lastgroup=$lastgroup&relevance21452=1&relevance21458=1\
    &relevance21462=1&relevance21463=1&relevance21464=1&relevance21465=1&relevance21466=0&relevanceG1=1\
    &move=movenext&thisstep=$thisstep&sid=$sid&start_time=$start_time&LEMpostKey=$lempostkey&token=$token" $survey_url >output.txt
    get_data

    # Submit second page
    # # 2021
    # curl -Ss -b cookies.txt -H "Content-Type: application/x-www-form-urlencoded" \
    #     -d "fieldnames=269653X1358X20881M01%7C269653X1358X20881M02%7C269653X1358X20881M03%7C269653X1358X20881M04\
    # %7C269653X1358X20881M05%7C269653X1358X20881M06%7C269653X1358X20881M07%7C269653X1358X20881M08\
    # %7C269653X1358X20881M09%7C269653X1358X20881M10%7C269653X1358X20881M11%7C269653X1358X20881M12\
    # %7C269653X1358X20881M13&java269653X1358X20881M01=MH05&269653X1358X20881M01=MH05\
    # &java269653X1358X20881M02=MH05&269653X1358X20881M02=MH05&java269653X1358X20881M03=MH05\
    # &269653X1358X20881M03=MH05&java269653X1358X20881M04=MH05&269653X1358X20881M04=MH05&java269653X1358X20881M05=MH05\
    # &269653X1358X20881M05=MH05&java269653X1358X20881M06=MH05&269653X1358X20881M06=MH05&java269653X1358X20881M07=MH05\
    # &269653X1358X20881M07=MH05&java269653X1358X20881M08=MH05&269653X1358X20881M08=MH05&java269653X1358X20881M09=MH05\
    # &269653X1358X20881M09=MH05&java269653X1358X20881M10=MH05&269653X1358X20881M10=MH05&java269653X1358X20881M11=MH05\
    # &269653X1358X20881M11=MH05&java269653X1358X20881M12=MH05&269653X1358X20881M12=MH05&java269653X1358X20881M13=MH05\
    # &269653X1358X20881M13=MH05&lastgroup=$lastgroup&relevance20881=1&relevance20882=1&relevanceG2=1\
    # &move=movenext&thisstep=$thisstep&sid=$sid&start_time=$start_time&LEMpostKey=$lempostkey&token=$token" $survey_url >output.txt
    # 2022

    curl -k -Ss -b cookies.txt -H "Content-Type: application/x-www-form-urlencoded" \

        -d "fieldnames=934395X1372X21459MH01%7C934395X1372X21459MH02%7C934395X1372X21459MH03\
    %7C934395X1372X21459MH04%7C934395X1372X21459MH05%7C934395X1372X21459MH06%7C934395X1372X21459MH07\
    %7C934395X1372X21459MH08%7C934395X1372X21459MH09%7C934395X1372X21459MH10%7C934395X1372X21459MH11\
    %7C934395X1372X21459MH12%7C934395X1372X21459MH13&java934395X1372X21459MH01=MH05&934395X1372X21459MH01=MH05\
    &java934395X1372X21459MH02=MH05&934395X1372X21459MH02=MH05&java934395X1372X21459MH03=MH05\
    &934395X1372X21459MH03=MH05&java934395X1372X21459MH04=MH05&934395X1372X21459MH04=MH05\
    &java934395X1372X21459MH05=MH05&934395X1372X21459MH05=MH05&java934395X1372X21459MH06=MH05\
    &934395X1372X21459MH06=MH05&java934395X1372X21459MH07=MH05&934395X1372X21459MH07=MH05\
    &java934395X1372X21459MH08=MH05&934395X1372X21459MH08=MH05&java934395X1372X21459MH09=MH05\
    &934395X1372X21459MH09=MH05&java934395X1372X21459MH10=MH05&934395X1372X21459MH10=MH05\
    &java934395X1372X21459MH11=MH05&934395X1372X21459MH11=MH05&java934395X1372X21459MH12=MH05\
    &934395X1372X21459MH12=MH05&java934395X1372X21459MH13=MH05&934395X1372X21459MH13=MH05\
    &lastgroup=934395X1372&relevance21459=1&relevance21460=1&relevanceG2=1\
    &move=movenext&thisstep=$thisstep&sid=$sid&start_time=$start_time&LEMpostKey=$lempostkey&token=$token" $survey_url >output.txt
    get_data

    # Submit last page
    # # 2021
    # curl -Ss -b cookies.txt -H "Content-Type: application/x-www-form-urlencoded" \
    #     -d "fieldnames=269653X1359X20875%7C269653X1359X20883&269653X1359X20875=&269653X1359X20883=\
    # &lastgroup=$lastgroup&relevance20875=1&relevance20883=1&relevanceG3=1\
    # &move=movenext&thisstep=$thisstep&sid=$sid&start_time=$start_time&LEMpostKey=$lempostkey&token=$token" $survey_url >output.txt
    # 2022

    curl -k -Ss -b cookies.txt -H "Content-Type: application/x-www-form-urlencoded" \

        -d "fieldnames=934395X1373X21453%7C934395X1373X21461&934395X1373X21453=&934395X1373X21461=\
    &lastgroup=934395X1373&relevance21453=1&relevance21461=1&relevanceG3=1\
    &move=movenext&thisstep=$thisstep&sid=$sid&start_time=$start_time&LEMpostKey=$lempostkey&token=$token" $survey_url >output.txt
    get_data

done