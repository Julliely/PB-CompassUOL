*** Settings ***
Documentation    Cenários de testes do cadastro de usuários

Resource    ../resources/base.resource

Test Setup    Start Session
Test Teardown    Take Screenshot
Library    String

*** Test Cases ***
Deve poder cadastrar um novo usuário

    ${user}    Create Dictionary    
    ...    name=teste    
    ...    email=teste@gmail.com    
    ...    password=teste123


    Remove user from database    ${user}[email]

    Go to signup page
    Submit signup from    ${user}
    Notice should be    Boas vindas ao Mark85, o seu gerenciador de tarefas.

Não deve permitir o cadastro com o email duplicado
    [Tags]    dup

    ${user}    Create Dictionary    
    ...    name=teste dois   
    ...    email=testedois@gmail.com    
    ...    password=teste123

    Remove user from database    ${user}[email]
    Insert user from database    ${user}

    Go to signup page
    Submit signup from    ${user}
    Notice should be    Oops! Já existe uma conta com o e-mail informado.

Campos obrigatórios
    [Tags]    required

    ${user}    Create Dictionary    
    ...    name=${EMPTY}
    ...    email=${EMPTY}
    ...    password=${EMPTY}
    
    Go to signup page
    Submit signup from    ${user}

    Alert should be    Informe seu nome completo
    Alert should be    Informe seu e-email
    Alert should be    Informe uma senha com pelo menos 6 digitos          

Não deve cadastrar com email inválido
    [Tags]    inv_email

    ${user}    Create Dictionary    
    ...    name=email invalido
    ...    email=emailinvalido.com.br
    ...    password=teste123
    
    Go to signup page
    Submit signup from    ${user}

    Alert should be    Digite um e-mail válido

Não deve cadastrar com senha muito curta
    [Tags]    temp
    @{password_list}    Create List    1    12    123   1234    12345 

    FOR    ${password}    IN    @{password_list}
     ${user}    Create Dictionary    
    ...    name=senha curta
    ...    email=senhacurta@gmail.com
    ...    password=${password}
    
    Go to signup page
    Submit signup from    ${user}

    Alert should be    Informe uma senha com pelo menos 6 digitos
        
    END
