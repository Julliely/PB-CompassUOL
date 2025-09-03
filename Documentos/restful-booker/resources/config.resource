*** Settings ***
Library    RequestsLibrary

*** Variables ***
${BASE_URL}    https://restful-booker.herokuapp.com
${USERNAME}    admin
${PASSWORD}    password123

*** Keywords ***
Iniciar Sessao
    Create Session    restful    ${BASE_URL}    verify=${False}

Headers Autenticados
    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    ...    Cookie=token=${TOKEN}
    [Return]    ${headers}