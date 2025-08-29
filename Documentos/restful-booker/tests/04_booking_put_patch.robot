*** Settings ***
Library    RequestsLibrary
Resource   ../resources/keywords.resource
Suite Setup    Setup Booking

*** Test Cases ***
Atualizar Reserva
    [Documentation]    Atualiza uma reserva existente com token
    Atualizar Reserva    ${NEW_BOOKING_ID}

Atualizar Reserva Parcial
    [Documentation]    Atualiza parcialmente uma reserva existente com token
    Atualizar Reserva Parcial    ${NEW_BOOKING_ID}

Atualizar Sem Token
    [Documentation]    Tenta atualizar reserva sem token e espera 403
    Criar Nova Reserva Temporaria
    Atualizar Reserva Sem Token    ${TEMP_BOOKING_ID}

*** Keywords ***
Setup Booking
    Iniciar Sessao
    Gerar Token
    Criar Nova Reserva

Criar Nova Reserva Temporaria
    [Documentation]    Cria uma reserva temporária para testes negativos
    Criar Nova Reserva    Teste    Negativo
    Set Suite Variable    ${TEMP_BOOKING_ID}    ${NEW_BOOKING_ID}