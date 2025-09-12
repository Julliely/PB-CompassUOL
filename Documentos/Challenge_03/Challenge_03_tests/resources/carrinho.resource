*** Settings ***
Library    RequestsLibrary

*** Variables ***
${CARRINHOS_ENDPOINT}    /carrinhos

*** Keywords ***
*** Keywords ***
POST Carrinho
    [Arguments]    ${body}    ${token}
    &{headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    POST On Session    api    ${CARRINHOS_ENDPOINT}    json=${body}    headers=${headers}    expected_status=any
    [Return]    ${response}

GET Carrinho By Id
    [Arguments]    ${carrinho_id}    ${token}
    &{headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    GET On Session    api    ${CARRINHOS_ENDPOINT}/${carrinho_id}    headers=${headers}    expected_status=any
    [Return]    ${response}

DELETE Carrinho By Id
    [Arguments]    ${carrinho_id}    ${token}
    &{headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    DELETE On Session    api    ${CARRINHOS_ENDPOINT}/${carrinho_id}    headers=${headers}    expected_status=any
    [Return]    ${response}
