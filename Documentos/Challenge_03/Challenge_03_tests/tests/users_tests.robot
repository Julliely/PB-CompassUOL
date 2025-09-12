*** Settings ***
Resource    ../resources/users.resource
Library     Collections
Library    RequestsLibrary
Library    FakerLibrary

*** Test Cases ***
POST Usuario Valido Deve Retornar 201
    Criar Sessao
    ${email}=    FakerLibrary.Email
    ${response}=    POST Usuario    Fulano da Silva    ${email}    teste    true
    Should Be Equal As Integers    ${response.status_code}    201
    Dictionary Should Contain Value    ${response.json()}    Cadastro realizado com sucesso

POST Usuario Com Email Ja Cadastrado Deve Retornar 400
    Criar Sessao
    ${response}=    POST Usuario    Fulano da Silva    beltrano@qa.com.br    teste    true
    Should Be Equal As Integers    ${response.status_code}    400
    Dictionary Should Contain Value    ${response.json()}    Este email já está sendo usado

POST Usuario Campos Obrigatorios Vazios Deve Retornar 400
    Criar Sessao
    ${response}=    POST Usuario    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}
    Should Be Equal As Integers    ${response.status_code}    400
    ${body}=    Set Variable    ${response.json()}
    Log To Console    ${body}
    Dictionary Should Contain Key    ${body}    nome
    Should Be Equal As Strings    ${body["nome"]}    nome não pode ficar em branco
    Dictionary Should Contain Key    ${body}    email
    Should Be Equal As Strings    ${body["email"]}    email não pode ficar em branco
    Dictionary Should Contain Key    ${body}    password
    Should Be Equal As Strings    ${body["password"]}    password não pode ficar em branco
    Dictionary Should Contain Key    ${body}    administrador
    Should Be Equal As Strings    ${body["administrador"]}    administrador deve ser 'true' ou 'false'

POST Usuario Gmail Deve Retornar Erro
    [Documentation]    Teste de regressão - atualmente falha, pois a API aceita Hotmail.
    [Tags]    regressão
    Criar Sessao
    ${response}=    POST Usuario    Teste Hotmail    testegmail@gmail.com    teste123    true
    Should Not Be Equal As Integers    ${response.status_code}    201

POST Usuario Email Invalido Deve Retornar Erro
    [Documentation]    Teste de regressão - atualmente falha, pois a API aceita Email invalido.
    [Tags]    regressão
    Criar Sessao
    ${response}=    POST Usuario    Usuario Invalido    usuario_invalido    teste123    true
    Should Not Be Equal As Integers    ${response.status_code}    201

POST Usuario Senha Curta Deve Retornar Erro
    [Documentation]    Teste de regressão - atualmente falha, pois a API aceita senha curta.
    [Tags]    regressão
    Criar Sessao
    ${response}=    POST Usuario    Usuario Senha Curta    senhaCurta@qa.com    123    true
    Should Not Be Equal As Integers    ${response.status_code}    201

POST Usuario Senha Longa Deve Retornar Erro
    [Documentation]    Teste de regressão - atualmente falha, pois a API aceita senha longa.
    [Tags]    regressão
    Criar Sessao
    ${response}=    POST Usuario   Usuario Senha Longa    senhaLonga@qa.com    1234567890123    true
    Should Not Be Equal As Integers    ${response.status_code}    201

GET Listar todos os usuários
    ${response}=    GET All Users
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    quantidade
    Dictionary Should Contain Key    ${response.json()}    usuarios
    Should Not Be Empty    ${response.json()["usuarios"]}    0

GET Listar usuário por id existente
    ${all_users}=    GET All Users
    ${id}=    Set Variable    ${all_users.json()["usuarios"][0]["_id"]}
    ${response}=    Get User By Id    ${id}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    nome
    Dictionary Should Contain Key    ${response.json()}    email
    Dictionary Should Contain Key    ${response.json()}    administrador

GET Listar usuário com id inválido
    Criar Sessao
    ${response}=    GET User By Id    id_invalido_123
    Should Be Equal As Integers    ${response.status_code}    400
    ${body}=    Set Variable    ${response.json() }
    Log To Console    ${body}
    Dictionary Should Contain Key    ${body}    id
    Should Be Equal As Strings    ${body["id"]}    id deve ter exatamente 16 caracteres alfanuméricos

PUT Atualização Completa do Usuário Deve Retornar 200
    Criar Sessao
    ${email}=    FakerLibrary.Email
    ${response_criar}=    POST Usuario    Usuario Put Teste    ${email}    senha123    true
    ${id}=    Set Variable    ${response_criar.json()["_id"]}

    ${novo_email}=    FakerLibrary.Email
    ${response_put}=    PUT Usuario    ${id}    Usuario Atualizado    ${novo_email}    novaSenha123    false
    Should Be Equal As Integers    ${response_put.status_code}    200
    Dictionary Should Contain Value    ${response_put.json()}    Registro alterado com sucesso 

PUT Atualização Parcial Deve Retornar 200
    Criar Sessao
    ${email}=    FakerLibrary.Email
    ${response_criar}=    POST Usuario    Usuario Parcial    ${email}    senha123    true
    ${id}=    Set Variable    ${response_criar.json()["_id"]}

    ${response_put}=    PUT Usuario    ${id}    Usuario Parcial Atualizado    ${email}    senha123    true
    Should Be Equal As Integers    ${response_put.status_code}    200
    Dictionary Should Contain Value    ${response_put.json()}    Registro alterado com sucesso 

PUT Usuario Com Email Duplicado Deve Retornar 400
    Criar Sessao
    ${email1}=    FakerLibrary.Email
    ${email2}=    FakerLibrary.Email
    ${response1}=    POST Usuario    Usuario Um    ${email1}    senha123    true
    ${id1}=    Set Variable    ${response1.json()["_id"]}
    ${response2}=    POST Usuario    Usuario Dois    ${email2}    senha123    true
    ${id2}=    Set Variable    ${response2.json()["_id"]}
    ${response_put}=    PUT Usuario    ${id2}    Usuario Dois Atualizado    ${email1}    senha123    true
    Should Be Equal As Integers    ${response_put.status_code}    400

PUT Usuario ID Inexistente Deve Cadastrar Novo Usuario
    Criar Sessao
    ${email}=    FakerLibrary.Email
    ${id_inexistente}=    Set Variable    1234567890abcdef
    ${response}=    PUT Usuario    ${id_inexistente}    Fulano da Silva    ${email}    teste    true
    Should Be Equal As Integers    ${response.status_code}    201
    ${body}=    Set Variable    ${response.json()}
    Log To Console    ${body}
    Dictionary Should Contain Key    ${body}    message
    Should Be Equal As Strings    ${body["message"]}    Cadastro realizado com sucesso
    Dictionary Should Contain Key    ${body}    _id

DELETE Usuario Existente Deve Retornar 200
    Criar Sessao
    ${email}=    FakerLibrary.Email
    ${response_criar}=    POST Usuario    Usuario Delete Teste    ${email}    senha123    true
    ${id}=    Set Variable    ${response_criar.json()["_id"]}

    ${response_delete}=    DELETE Usuario    ${id}
    Should Be Equal As Integers    ${response_delete.status_code}    200
    Dictionary Should Contain Value    ${response_delete.json()}    Registro excluído com sucesso

DELETE Usuario Inexistente Deve Retornar 200 Sem Excluir
    Criar Sessao
    ${response_delete}=    DELETE Usuario    id_invalido_123
    Should Be Equal As Integers    ${response_delete.status_code}    200
    Dictionary Should Contain Value    ${response_delete.json()}    Nenhum registro excluído

DELETE Usuario Ja Excluido Deve Retornar 200 Nenhum Registro
    Criar Sessao
    ${email}=    FakerLibrary.Email
    ${response_criar}=    POST Usuario    Usuario Delete Again    ${email}    senha123    true
    ${id}=    Set Variable    ${response_criar.json()["_id"]}

    ${response_delete_1}=    DELETE Usuario    ${id}
    Should Be Equal As Integers    ${response_delete_1.status_code}    200
    Dictionary Should Contain Value    ${response_delete_1.json()}    Registro excluído com sucesso

    ${response_delete_2}=    DELETE Usuario    ${id}
    Should Be Equal As Integers    ${response_delete_2.status_code}    200
    Dictionary Should Contain Value    ${response_delete_2.json()}    Nenhum registro excluído 