*** Settings ***
Resource    ../resources/config.resource
Resource    ../resources/auth.resource
Resource    ../resources/booking.resource
Suite Setup    Setup Booking

*** Keywords ***
Setup Booking
    Iniciar Sessao
    Gerar Token
    Criar Nova Reserva

Criar Nova Reserva Temporaria
    Criar Nova Reserva    Teste    Temporario
    Set Suite Variable    ${TEMP_BOOKING_ID}    ${NEW_BOOKING_ID}

*** Test Cases ***
Deletar Reserva
    Deletar Reserva    ${NEW_BOOKING_ID}

Deletar Reserva Inexistente
    ${headers}=    Headers Autenticados
    ${response}=    DELETE On Session    restful    /booking/9999999    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    405

Deletar Sem Token
    Criar Nova Reserva Temporaria
    ${headers}=    Create Dictionary
    ${response}=    DELETE On Session    restful    /booking/${TEMP_BOOKING_ID}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    403