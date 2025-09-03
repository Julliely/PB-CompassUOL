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
    Criar Nova Reserva    Teste    Negativo
    Set Suite Variable    ${TEMP_BOOKING_ID}    ${NEW_BOOKING_ID}

*** Test Cases ***
Atualizar Reserva
    Atualizar Reserva    ${NEW_BOOKING_ID}

Atualizar Reserva Parcial
    Atualizar Reserva Parcial    ${NEW_BOOKING_ID}

Atualizar Sem Token
    [Documentation]    Deve falhar com 403, pois não há autenticação
    Criar Nova Reserva Temporaria
    ${response}=    Atualizar Reserva Sem Token    ${TEMP_BOOKING_ID}
    Should Be Equal As Integers    ${response.status_code}    403