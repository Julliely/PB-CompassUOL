*** Settings ***
Resource    ../configs/config.resource

*** Keywords ***
GET All Products
    ${response}=    GET On Session    api    ${PRODUCTS_ENDPOINT}    expected_status=any
    [Return]    ${response}

GET Product By Id
    [Arguments]    ${product_id}
    ${response}=    GET On Session    api    ${PRODUCTS_ENDPOINT}/${product_id}    expected_status=any
    [Return]    ${response}

POST Produto
    [Arguments]    ${nome}    ${preco}    ${descricao}    ${quantidade}    ${token}
    ${body}=    Create Dictionary
    ...    nome=${nome}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    POST On Session    api    ${PRODUCTS_ENDPOINT}    json=${body}    headers=${headers}    expected_status=any
    [Return]    ${response}

PUT Produto
    [Arguments]    ${product_id}    ${nome}    ${preco}    ${descricao}    ${quantidade}    ${token}
    ${body}=    Create Dictionary
    ...    nome=${nome}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    PUT On Session    api    ${PRODUCTS_ENDPOINT}/${product_id}    json=${body}    headers=${headers}    expected_status=any
    [Return]    ${response}

DELETE Produto
    [Arguments]    ${product_id}    ${token}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    DELETE On Session    api    ${PRODUCTS_ENDPOINT}/${product_id}    headers=${headers}    expected_status=any
    [Return]    ${response}