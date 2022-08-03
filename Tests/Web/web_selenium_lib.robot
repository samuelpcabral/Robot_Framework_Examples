*** Settings ***
Documentation     Simple test using Selenium, imported variables and keywords from python.
Suite Teardown    Close Browser
Library           BuiltIn
Library           SeleniumLibrary
Library           Keywords.py
Variables         Variables.py


*** Test Cases ***
Verify Checkbox
    [Documentation]    This test randomly marks 1 of the 4 checkboxes on the page and checks whether it is actually
    ...    checked. After that, the functionality of the "check all" button is tested.
    [Tags]    Web    Selenium
    Open Web Page
    Put All Uncheck
    Click Random Checkbox
    Click Check All
    Verify All Checkbox Check
    Click Uncheck All
    Verify All Checkbox Uncheck


*** Keywords ***
Open Web Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Click Random Checkbox
    ${NUMBER}    Generate Random Number    1    4
    ${CHECKBOX_NUMBER}    Replace Variables    ${CHECKBOX}
    Select Checkbox    ${CHECKBOX_NUMBER}
    Capture Page Screenshot
    Checkbox Should Be Selected    ${CHECKBOX_NUMBER}

Click Check All
    Click Element    ${ALL}

Click Uncheck All
    Click Element    ${ALL}

Put All Uncheck
    Wait Until Element Is Visible    ${ALL}
    Scroll Element Into View    ${ACCESSIBILITY}
    Click Element    ${ALL}
    Click Element   ${ALL}

Verify All Checkbox Check
    Capture Page Screenshot
    FOR    ${NUMBER}    IN RANGE    1    5
        ${CHECKBOX_NUMBER}    Replace Variables    ${CHECKBOX}
        Checkbox Should Be Selected    ${CHECKBOX_NUMBER}
    END

Verify All Checkbox Uncheck
    Capture Page Screenshot
    FOR    ${NUMBER}    IN RANGE    1    5
        ${CHECKBOX_NUMBER}    Replace Variables    ${CHECKBOX}
        Checkbox Should Not Be Selected    ${CHECKBOX_NUMBER}
    END
