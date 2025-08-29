*** Settings ***
Library    RequestsLibrary

*** Variables ***
${BASE_URL}    https://restful-booker.herokuapp.com
${USERNAME}    admin
${PASSWORD}    password123

*** Keywords ***
Iniciar Sessao
    Create Session    restful    ${BASE_URL}    verify=${False}

Gerar Token
    ${body}=    Create Dictionary    username=${USERNAME}    password=${PASSWORD}
    ${response}=    POST On Session    restful    /auth    json=${body}
    Should Be Equal As Strings    ${response.status_code}    200
    ${token}=    Set Variable    ${response.json()['token']}
    Set Suite Variable    ${TOKEN}    ${token}
    Log    Token gerado: ${TOKEN}

Criar Nova Reserva
    [Arguments]    ${firstname}=Joao    ${lastname}=Silva
    ${bookingdates}=    Create Dictionary    checkin=2025-09-01    checkout=2025-09-10
    ${body}=    Create Dictionary
    ...    firstname=${firstname}
    ...    lastname=${lastname}
    ...    totalprice=150
    ...    depositpaid=True
    ...    bookingdates=${bookingdates}
    ...    additionalneeds=Café da manhã
    ${response}=    POST On Session    restful    /booking    json=${body}
    Should Be Equal As Strings    ${response.status_code}    200
    ${id}=    Set Variable    ${response.json()['bookingid']}
    Set Suite Variable    ${NEW_BOOKING_ID}    ${id}
    Log    Nova reserva criada com ID: ${NEW_BOOKING_ID}

Listar Reservas
    ${response}=    GET On Session    restful    /booking
    Should Be Equal As Strings    ${response.status_code}    200
    Log    Reservas: ${response.json()}

Listar Reservas Por Nome
    [Arguments]    ${firstname}    ${lastname}
    ${params}=    Create Dictionary    firstname=${firstname}    lastname=${lastname}
    ${response}=    GET On Session    restful    /booking    params=${params}
    Should Be Equal As Strings    ${response.status_code}    200
    Log    Reservas filtradas por nome: ${response.json()}

Listar Reservas Por Datas
    [Arguments]    ${checkin}    ${checkout}
    ${params}=    Create Dictionary    checkin=${checkin}    checkout=${checkout}
    ${response}=    GET On Session    restful    /booking    params=${params}
    Should Be Equal As Strings    ${response.status_code}    200
    Log    Reservas filtradas por datas: ${response.json()}

Criar Reserva Sem Token
    ${bookingdates}=    Create Dictionary    checkin=2025-09-01    checkout=2025-09-10
    ${body}=    Create Dictionary
    ...    firstname=Ana
    ...    lastname=Souza
    ...    totalprice=120
    ...    depositpaid=True
    ...    bookingdates=${bookingdates}
    ...    additionalneeds=Almoço
    ${response}=    POST On Session    restful    /booking    json=${body}
    Should Be Equal As Strings    ${response.status_code}    200

Criar Reserva Dados Invalidos
    ${bookingdates}=    Create Dictionary    checkin=2025-09-01    checkout=2025-09-10
    ${body}=    Create Dictionary
    ...    firstname=12345
    ...    lastname=@!#
    ...    totalprice=150
    ...    depositpaid=True
    ...    bookingdates=${bookingdates}
    ...    additionalneeds=Café
    ${response}=    POST On Session    restful    /booking    json=${body}
    Should Be Equal As Strings    ${response.status_code}    200

Atualizar Reserva
    [Arguments]    ${booking_id}
    ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json    Cookie=token=${TOKEN}
    ${bookingdates}=    Create Dictionary    checkin=2025-09-05    checkout=2025-09-15
    ${body}=    Create Dictionary
    ...    firstname=Maria
    ...    lastname=Souza
    ...    totalprice=200
    ...    depositpaid=False
    ...    bookingdates=${bookingdates}
    ...    additionalneeds=Jantar
    ${response}=    PUT On Session    restful    /booking/${booking_id}    headers=${headers}    json=${body}
    Should Be Equal As Strings    ${response.status_code}    200

Atualizar Reserva Parcial
    [Arguments]    ${booking_id}
    ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json    Cookie=token=${TOKEN}
    ${body}=    Create Dictionary
    ...    totalprice=250
    ${response}=    PATCH On Session    restful    /booking/${booking_id}    headers=${headers}    json=${body}
    Should Be Equal As Strings    ${response.status_code}    200

Atualizar Reserva Sem Token
    [Arguments]    ${booking_id}
    ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json
    ${bookingdates}=    Create Dictionary    checkin=2025-09-05    checkout=2025-09-15
    ${body}=    Create Dictionary
    ...    firstname=Maria
    ...    lastname=Souza
    ...    totalprice=200
    ...    depositpaid=False
    ...    bookingdates=${bookingdates}
    ...    additionalneeds=Jantar
    ${response}=    PUT On Session    restful    /booking/${booking_id}    headers=${headers}    json=${body}
    Should Be Equal As Strings    ${response.status_code}    403

Deletar Reserva
    [Arguments]    ${booking_id}
    ${headers}=    Create Dictionary    Cookie=token=${TOKEN}
    ${response}=    DELETE On Session    restful    /booking/${booking_id}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    201

Deletar Reserva Inexistente
    ${headers}=    Create Dictionary    Cookie=token=${TOKEN}
    ${response}=    DELETE On Session    restful    /booking/9999999    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    405

Deletar Reserva Sem Token
    [Arguments]    ${booking_id}
    ${headers}=    Create Dictionary
    ${response}=    DELETE On Session    restful    /booking/${booking_id}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    403