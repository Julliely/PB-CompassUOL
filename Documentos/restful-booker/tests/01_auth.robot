*** Settings ***
Library    RequestsLibrary
Resource   ../resources/keywords.resource
Suite Setup    Iniciar Sessao

*** Test Cases ***
Criar Token de Autenticação
    Gerar Token