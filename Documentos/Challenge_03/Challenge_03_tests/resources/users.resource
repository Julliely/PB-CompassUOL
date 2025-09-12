*** Settings ***
Resource    ../configs/config.resource

*** Keywords ***
POST Usuario
    [Arguments]    ${nome}    ${email}    ${senha}    ${admin}
    ${body}=    Create Dictionary
    ...    nome=${nome}
    ...    email=${email}
    ...    password=${senha}
    ...    administrador=${admin}
    ${response}=    POST On Session    api    ${USERS_ENDPOINT}    json=${body}    expected_status=any
    [Return]    ${response}

GET All Users
    ${response}=    GET    ${BASE_URL}${USERS_ENDPOINT}
    [Return]    ${response}

GET User By Id
    [Arguments]    ${user_id}
    ${response}=    GET    ${BASE_URL}${USERS_ENDPOINT}/${user_id}    expected_status=any
    [Return]    ${response}

PUT Usuario
    [Arguments]    ${user_id}    ${nome}    ${email}    ${senha}    ${admin}
    ${body}=    Create Dictionary
    ...    nome=${nome}
    ...    email=${email}
    ...    password=${senha}
    ...    administrador=${admin}
    ${response}=    PUT On Session    api    ${USERS_ENDPOINT}/${user_id}    json=${body}    expected_status=any
    [Return]    ${response}

DELETE Usuario
    [Arguments]    ${user_id}
    ${response}=    DELETE On Session    api    ${USERS_ENDPOINT}/${user_id}    expected_status=any
    [Return]    ${response}

POST Login
    [Arguments]    ${email}    ${senha}
    ${body}=    Create Dictionary
    ...    email=${email}
    ...    password=${senha}
    ${response}=    POST On Session    api    ${LOGIN_ENDPOINT}    json=${body}    expected_status=any
    [Return]    ${response}
