*** Settings ***
Documentation     Test suite for demonstration only, using robotframework==5.0.1, robotframework-requests==0.9.3
...    and robotframework-jsonlibrary==0.4.1
Library           Collections
Library           RequestsLibrary
Library           JSONLibrary


*** Variables ***
# Open Weather
${WEATHER_URL}    http://api.openweathermap.org/data/2.5/weather
&{PARAMS}    id=2739187    appid=921689f02b330ad351a53b601daf96bc    units=metric

# Github
${GITHUB_URL}    http://api.github.com/users/


*** Test Cases ***
Open Weather
    [Documentation]    Call to Open Weather REST API passing parameters.
    [Tags]    Webservice    REST
    Get OpenWeather API Data
    Show City "country" Information
    Show City "name" Information
    Show City "temp_max" Information
    Show City "temp_min" Information

Show Github User Data
    [Documentation]    Retrive information about an user in github API.
    [Tags]    Webservice    REST
    Get Github User "samuelpcabral" API Data
    Show User "name" Information
    Show User "location" Information
    Show User "company" Information
    Get Github User "john" API Data
    Show User "name" Information
    Show User "followers" Information
    Show User "following" Information


*** Keywords ***
Get OpenWeather API Data
    ${RESPONSE}    GET    ${WEATHER_URL}    expected_status=200    params=&{PARAMS}
    ${RESPONSE_JSON}    Set Variable    ${RESPONSE.json()}
    comment    Complete response as pretty print JSON
    Log    ${RESPONSE_JSON}    formatter=repr
    Set Test Variable    ${RESPONSE_JSON}

Show City "${DATA}" Information
    [Documentation]    Getting information generically through JSONPATH (The city is on &{PARAMS} 'id')
    ${INFO}    Get Value From Json    ${RESPONSE_JSON}    $..${DATA}
    Log    ${DATA}: ${INFO[0]}

Get Github user "${USER}" API data
    ${RESPONSE}    GET    ${GITHUB_URL}${USER}    expected_status=200
    ${RESPONSE_JSON}    Set Variable    ${RESPONSE.json()}
    comment    Complete response as pretty print JSON
    Log    ${RESPONSE_JSON}    formatter=repr
    Set Test Variable    ${RESPONSE_JSON}

Show user "${DATA}" Information
    [Documentation]    Getting information generically through python dict
    Log    ${DATA}: ${RESPONSE_JSON["${DATA}"]}
