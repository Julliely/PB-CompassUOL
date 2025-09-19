*** Settings ***
Documentation    Cenários de testes da autenticação do usuário

Library    Collections
Resource    ../resources/base.resource
Resource    ../resources/pages/components/Notice.resource

Test Setup    Start Session
Test Teardown    Take Screenshot

*** Test Cases ***
Deve poder logar com um usuário pré-cadastrado

    ${user}    Create Dictionary    
    ...    name=teste
    ...    email=teste@gmail.com
    ...    password=teste123

    Remove user from database    ${user}[email]
    Insert user from database    ${user}
 
    Submit login from    ${user}
    User should be logged in     ${user}[name]

Não deve logar com senha inválida
    ${user}    Create Dictionary    
    ...    name=senhaincorreta
    ...    email=senhaincorreta@gmail.com
    ...    password=teste123

    Remove user from database    ${user}[email]
    Insert user from database    ${user}

    Set To Dictionary    ${user}    password=123teste
 
    Submit login from    ${user}
    Notice should be    Ocorreu um erro ao fazer login, verifique suas credenciais.
