*** Settings ***
Documentation     Simple test using Selenium, imported variables and keywords from python.
Suite Setup       Open Page and Close Pop Up
Suite Teardown    Close Browser
Library           SeleniumLibrary
Library           BuiltIn
Library           Keywords.py
Variables         Variables.py

*** Test Cases ***
Checkbox
    [Documentation]    This test randomly marks 1 of the 4 checkboxes on the page and checks whether it is actually
    ...    checked. After that, the functionality of the "check all" button is tested.
    [Tags]    Web
    Open Checkbox Menu
    Click Random Checkbox
    Click Check All
    Verify All Checkbox Check
    Click Uncheck All
    Verify ALl Checkbox Uncheck

*** Keywords ***
Open Web Page
    Open Browser    ${url}    ${browser}
    Maximize Browser Window

Close the Pop Up
    Wait Until Element Is Visible    ${pop_up_no_button}
    Click Element    ${pop_up_no_button}

Open Page and Close Pop Up
    Open Web Page
    Close the Pop Up

Open Checkbox Menu
    Click Element    ${input_forms}
    Click Element    ${checkbox_demo}
    Scroll Element Into View    ${check_button}
    Capture Page Screenshot

Click Random Checkbox
    ${number}    Generate Random Number    1    4
    ${checkbox_number}    Replace Variables    ${checkbox}
    Select Checkbox    ${checkbox_number}
    Capture Page Screenshot
    Checkbox Should Be Selected    ${checkbox_number}

Click Check All
    Click Button    ${check_button}

Click Uncheck All
    Click Button    ${check_button}

Verify All Checkbox Check
    Capture Page Screenshot
    FOR    ${number}    IN RANGE    1    5
        ${checkbox_number}    Replace Variables    ${checkbox}
        Checkbox Should Be Selected    ${checkbox_number}
    END

Verify ALl Checkbox Uncheck
    Capture Page Screenshot
    FOR    ${number}    IN RANGE    1    5
        ${checkbox_number}    Replace Variables    ${checkbox}
        Checkbox Should Not Be Selected    ${checkbox_number}
    END