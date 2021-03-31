*** Settings ***
Documentation     Simple test using Browser library, imported variables and keywords from python.
Suite Setup       Open Page and Close Pop Up
Suite Teardown    Close Browser
Library           Browser
Library           BuiltIn
Library           Keywords.py
Variables         Variables.py

*** Test Cases ***
Verify Checkbox
    [Documentation]    This test randomly marks 1 of the 4 checkboxes on the page and checks whether it is actually
    ...    checked. After that, the functionality of the "check all" button is tested.
    [Tags]    Web    Browser
    Open Checkbox Menu
    Click Random Checkbox
    Click Check All
    Verify All Checkbox Check
    Click Uncheck All
    Verify All Checkbox Uncheck

*** Keywords ***
Open Web Page
    New Browser    ${web_browser}    headless=false
    New Context    viewport={'width': 1024, 'height': 768}
    new page    ${url}

Close the Pop Up
    Wait For Elements State    ${pop_up_no_button}
    Click    ${pop_up_no_button}

Open Page and Close Pop Up
    Open Web Page
    Close the Pop Up

Open Checkbox Menu
    Click    ${input_forms}
    Click    ${checkbox_demo}
    Scroll To    ${check_button}
    Take Screenshot

Click Random Checkbox
    ${number}    Generate Random Number    1    4
    ${checkbox_number}    Replace Variables    ${checkbox}
    Check Checkbox    ${checkbox_number}
    Take Screenshot
    Get Checkbox State    ${checkbox_number}    expected_state=checked

Click Check All
    Click    ${check_button}

Click Uncheck All
    Click    ${check_button}

Verify All Checkbox Check
    Take Screenshot
    FOR    ${number}    IN RANGE    1    5
        ${checkbox_number}    Replace Variables    ${checkbox}
        Get Checkbox State    ${checkbox_number}    expected_state=checked
    END

Verify All Checkbox Uncheck
    Take Screenshot
    FOR    ${number}    IN RANGE    1    5
        ${checkbox_number}    Replace Variables    ${checkbox}
        Get Checkbox State    ${checkbox_number}    expected_state=unchecked
    END