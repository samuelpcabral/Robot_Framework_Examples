*** Settings ***
Documentation     Simple test using Browser library, imported variables and keywords from python.
#Suite Teardown    Close Browser
Library           BuiltIn
Library           Browser
Library           Keywords.py
Variables         Variables.py


*** Test Cases ***
Verify Checkbox
    [Documentation]    This test randomly marks 1 of the 4 checkboxes on the page and checks whether it is actually
    ...    checked. After that, the functionality of the "check all" button is tested.
    [Tags]    Web    Browser
    Open Web Page
    Put All Uncheck
    Click Random Checkbox
    Click Check All
    Verify All Checkbox Check
    Click Uncheck All
    Verify All Checkbox Uncheck

*** Keywords ***
Open Web Page
    New Browser    ${WEB_BROWSER}    headless=false
    New Context    viewport={'width': 1024, 'height': 768}
    new page    ${URL}

Click Random Checkbox
    ${NUMBER}    Generate Random Number    1    4
    ${CHECKBOX_NUMBER}    Replace Variables    ${CHECKBOX}
    Check Checkbox    ${CHECKBOX_NUMBER}
    Take Screenshot
    Get Checkbox State    ${CHECKBOX_NUMBER}    ==    checked

Click Check All
    Click    ${ALL}

Click Uncheck All
    Click    ${ALL}

Put All Uncheck
    Wait For Elements State    ${ALL}
    Scroll To Element    ${ACCESSIBILITY}
    Click    ${ALL}
    Click    ${ALL}

Verify All Checkbox Check
    Take Screenshot
    FOR    ${NUMBER}    IN RANGE    1    5
        ${CHECKBOX_NUMBER}    Replace Variables    ${CHECKBOX}
        Get Checkbox State    ${CHECKBOX_NUMBER}    ==    checked
    END

Verify All Checkbox Uncheck
    Take Screenshot
    FOR    ${NUMBER}    IN RANGE    1    5
        ${CHECKBOX_NUMBER}    Replace Variables    ${CHECKBOX}
        Get Checkbox State    ${CHECKBOX_NUMBER}    ==    unchecked
    END
