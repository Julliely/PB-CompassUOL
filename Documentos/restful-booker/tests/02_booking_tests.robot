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

*** Test Cases ***
Listar Todas Reservas
    Listar Reservas

Filtrar Reservas Por Nome
    Listar Reservas Por Nome    Joao    Silva

Filtrar Reservas Por Datas
    Listar Reservas Por Datas    2025-09-01    2025-09-10

Criar Reserva Sem Token
    Criar Reserva Sem Token

Criar Reserva Dados Invalidos
    Criar Reserva Dados Invalidos