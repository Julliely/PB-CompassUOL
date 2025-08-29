*** Settings ***
Library    RequestsLibrary
Resource   ../resources/keywords.resource
Suite Setup    Setup Booking

*** Test Cases ***
Deletar Reserva
    [Documentation]    Deleta uma reserva existente com token
    Deletar Reserva    ${NEW_BOOKING_ID}

Deletar Reserva Inexistente
    [Documentation]    Tenta deletar uma reserva que não existe
    ${response}=    DELETE On Session    restful    /booking/9999999    headers=${EMPTY_HEADERS}
    Should Be True    '${response.status_code}' in ['404','405']

Deletar Sem Token
    [Documentation]    Tenta deletar reserva existente sem token
    Criar Nova Reserva Temporaria
    ${response}=    DELETE On Session    restful    /booking/${TEMP_BOOKING_ID}    headers=${EMPTY_HEADERS}
    Should Be Equal As Strings    ${response.status_code}    403

*** Keywords ***
Setup Booking
    Iniciar Sessao
    Gerar Token
    Criar Nova Reserva

Criar Nova Reserva Temporaria
    [Documentation]    Cria uma reserva temporária para teste de delete sem token
    Criar Nova Reserva    Teste    Temporario
    Set Suite Variable    ${TEMP_BOOKING_ID}    ${NEW_BOOKING_ID}
