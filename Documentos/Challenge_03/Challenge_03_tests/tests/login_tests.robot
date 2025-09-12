*** Settings ***
Resource    ../resources/users.resource
Library     Collections
Library    RequestsLibrary
Library    FakerLibrary

*** Test Cases ***
POST Login Usuario Valido Deve Retornar 200
    Criar Sessao
    ${email}=    FakerLibrary.Email
    ${response_criar}=    POST Usuario    Usuario Login Teste    ${email}    senha123    true

    ${response_login}=    POST Login    ${email}    senha123
    Should Be Equal As Integers    ${response_login.status_code}    200
    Dictionary Should Contain Value    ${response_login.json()}    Login realizado com sucesso
    Dictionary Should Contain Key    ${response_login.json()}    authorization

POST Login Com Email Invalido Deve Retornar 401
    Criar Sessao
    ${response_login}=    POST Login    email_invalido@qa.com    senha123
    Should Be Equal As Integers    ${response_login.status_code}    401
    Dictionary Should Contain Value    ${response_login.json()}    Email e/ou senha inválidos

POST Login Com Senha Incorreta Deve Retornar 401
    Criar Sessao
    ${email}=    FakerLibrary.Email
    ${response_criar}=    POST Usuario    Usuario Senha Incorreta    ${email}    senha123    true

    ${response_login}=    POST Login    ${email}    senhaErrada
    Should Be Equal As Integers    ${response_login.status_code}    401
    Dictionary Should Contain Value    ${response_login.json()}    Email e/ou senha inválidos

POST Login Com Campos Vazios Deve Retornar 400
    Criar Sessao
    ${response_login}=    POST Login    ${EMPTY}    ${EMPTY}
    Should Be Equal As Integers    ${response_login.status_code}    400
    Dictionary Should Contain Key    ${response_login.json()}    email
    Dictionary Should Contain Key    ${response_login.json()}    password
    Should Be Equal As Strings    ${response_login.json()["email"]}    email não pode ficar em branco
    Should Be Equal As Strings    ${response_login.json()["password"]}    password não pode ficar em branco

