*** Settings ***
Library    RequestsLibrary
Resource   ../resources/keywords.resource
Suite Setup    Setup Auth

*** Test Cases ***
Criar Nova Reserva
    Criar Nova Reserva    Joao    Silva

Criar Reserva Sem Token
    Criar Reserva Sem Token

Criar Reserva Dados Invalidos
    Criar Reserva Dados Invalidos

*** Keywords ***
Setup Auth
    Iniciar Sessao
    Gerar Token