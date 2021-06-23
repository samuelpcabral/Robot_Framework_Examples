*** Settings ***
Library           RequestsLibrary
Library           JSONLibrary
Library           Collections

*** Variables ***
# Open Weather
${weather_url}    http://api.openweathermap.org/data/2.5/weather
&{params}    id=2739187    appid=921689f02b330ad351a53b601daf96bc    units=metric

# Github
${github_url}    http://api.github.com/users/

*** Test Cases ***
Open Weather
    [Documentation]    Call to Open Weather REST API passing parameters.
    [Tags]    Webservice    REST
    Get OpenWeather API data
    Show City "country" Information
    Show City "name" Information
    Show City "temp_max" Information
    Show City "temp_min" Information

Show Github User Data
    [Documentation]    Retrive information about an user in github API.
    [Tags]    Webservice    REST
    Get Github user "samuelpcabral" API data
    Show user "name" Information
    Show user "location" Information
    Show user "company" Information
    Get Github user "john" API data
    Show user "name" Information
    Show user "followers" Information
    Show user "following" Information

*** Keywords ***
Get OpenWeather API data
    ${response}    GET    ${weather_url}    expected_status=200    params=&{params}
    ${response_json}    Set Variable    ${response.json()}
    comment    Complete response as pretty print JSON
    Log    ${response_json}    repr=True
    Set Test Variable    ${response_json}

Show City "${data}" Information
    [Documentation]    Getting information generically through JSONPATH (The city is on &{params} 'id')
    ${info}    Get Value From Json    ${response_json}    $..${data}
    Log    ${data}: ${info[0]}

Get Github user "${user}" API data
    ${response}    GET    ${github_url}${user}    expected_status=200
    ${response_json}    Set Variable    ${response.json()}
    comment    Complete response as pretty print JSON
    Log    ${response_json}    repr=True
    Set Test Variable    ${response_json}

Show user "${data}" Information
    [Documentation]    Getting information generically through python dict
    Log    ${data}: ${response_json["${data}"]}