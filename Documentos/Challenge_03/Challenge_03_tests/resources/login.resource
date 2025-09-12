*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${LOGIN_ENDPOINT}      /login

*** Keywords ***
POST Login
    [Arguments]    ${email}    ${password}
    ${body}=    Create Dictionary
    ...    email=${email}
    ...    password=${password}
    ${response}=    POST On Session    api    ${LOGIN_ENDPOINT}    json=${body}    expected_status=any
    [Return]    ${response}
    