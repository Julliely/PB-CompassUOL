*** Settings ***
Resource    config.resource

*** Keywords ***
Gerar Token
    ${body}=    Create Dictionary    username=${USERNAME}    password=${PASSWORD}
    ${response}=    POST On Session    restful    /auth    json=${body}
    Should Be Equal As Strings    ${response.status_code}    200
    ${token}=    Set Variable    ${response.json()['token']}
    Set Suite Variable    ${TOKEN}    ${token}
    Log    Token gerado: ${TOKEN}