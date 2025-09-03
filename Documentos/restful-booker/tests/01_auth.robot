*** Settings ***
Resource    ../resources/config.resource
Resource    ../resources/auth.resource
Suite Setup    Iniciar Sessao

*** Test Cases ***
Criar Token de Autenticação
    Gerar Token