*** Settings ***
Library    RequestsLibrary
Resource   ../resources/keywords.resource
Suite Setup    Setup Booking

*** Test Cases ***
Listar Todas Reservas
    Listar Reservas

Filtrar Reservas Por Nome
    Listar Reservas Por Nome    Joao    Silva

Filtrar Reservas Por Datas
    Listar Reservas Por Datas    2025-09-01    2025-09-10

*** Keywords ***
Setup Booking
    Iniciar Sessao
    Gerar Token
    Criar Nova Reserva