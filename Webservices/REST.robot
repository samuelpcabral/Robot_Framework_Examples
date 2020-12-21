*** Settings ***
Library           RequestsLibrary
Library           JSONLibrary
Library           Collections

*** Variables ***
# Open Weather
&{params}    id=2739187    appid=921689f02b330ad351a53b601daf96bc    units=metric
# Github
${user}      samuelpcabral


*** Test Cases ***
Open_Weather
    [Documentation]    Call to REST webservice passing parameters.
    Connect OpenWeather API
    Show City Information

Get Github User
    [Documentation]    Retrive information about an user in github.
    Connect Github API
    Show user Information    ${user}


*** Keywords ***
Connect OpenWeather API
    Create Session    OpenWeather    http://api.openweathermap.org    disable_warnings=1

Show City Information
    [Documentation]    Getting the same information in two different ways. (The city is on parameter 'id')
    ${response}=    Get Request    OpenWeather    /data/2.5/weather    params=&{params}
    Log    Status code = ${response.status_code}
    comment    Complete response as pretty print JSON
    ${response_json}=    To Json    ${response.content}    pretty_print=True
    Log    ${response_json}
    comment    Accessing the values individually
    Log    City: ${response.json()["name"]}
    Log    Temperature: ${response.json()["main"]["temp"]}
    Log    Clime: ${response.json()["weather"][0]["main"]}
    comment    Handling the response as a JSON
    ${response_json}    Set Variable    ${response.json()}
    ${city}    Get Value From Json    ${response_json}    $.name
    ${temperature}    Get Value From Json    ${response_json}    $.main.temp
    ${clime}    Get Value From Json    ${response_json}    $.weather[0].main
    Log    City: ${city[0]}
    Log    Temperature: ${temperature[0]}
    Log    Clime: ${clime[0]}

Connect Github API
    Create Session    github    http://api.github.com    disable_warnings=1

Show user Information
    [Arguments]    ${username}
    ${response}=    Get Request    github    /users/${username}
    Log    ${response.json()["name"]}
    Log    ${response.json()["location"]}
    comment    Convert response as JSON to pretty print
    ${response_as_json}=    To Json    ${response.content}    pretty_print=True
    Log    ${response_as_json}
    comment    Convert all response as JSON to acces values with json path
    ${response_json}    Set Variable    ${response.json()}
    ${name}    Get Value From Json    ${response_json}    $..name
    ${location}    Get Value From Json    ${response_json}    $..location
    Log    ${name[0]}
    Log    ${location[0]}