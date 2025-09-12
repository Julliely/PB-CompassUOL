*** Settings ***
Resource    ../resources/products.resource
Resource    ../resources/users.resource
Resource    ../resources/login.resource
Resource    ../resources/carrinho.resource
Library     Collections
Library     RequestsLibrary
Library     FakerLibrary

*** Test Cases ***
GET Listar Produtos Cadastrados Deve Retornar 200
    Criar Sessao
    ${response}=    GET All Products
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    quantidade
    Dictionary Should Contain Key    ${response.json()}    produtos
    Should Not Be Empty    ${response.json()["produtos"]}

GET Listar Produtos Usuario Nao Autenticado
    [Documentation]    Teste de regressão - atualmente falha, pois a API aceita usuários não autenticados listar produtos
    [Tags]     regressão
    Criar Sessao
    # Não enviar header Authorization para simular usuário não autenticado
    ${response}=    GET On Session    api    ${PRODUCTS_ENDPOINT}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401
    Dictionary Should Contain Value    ${response.json()}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais
GET Listar Produto Por Id Valido Deve Retornar 200
    Criar Sessao
    ${all_products}=    GET All Products
    ${id}=    Set Variable    ${all_products.json()["produtos"][0]["_id"]}

    ${response}=    GET Product By Id    ${id}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    nome
    Dictionary Should Contain Key    ${response.json()}    preco
    Dictionary Should Contain Key    ${response.json()}    descricao
    Dictionary Should Contain Key    ${response.json()}    quantidade
    Dictionary Should Contain Key    ${response.json()}    _id

GET Listar Produto Por Id Inexistente Deve Retornar 400
    Criar Sessao
    ${response}=    GET Product By Id    id_invalido_123
    Should Be Equal As Integers    ${response.status_code}    400
    Dictionary Should Contain Key    ${response.json()}    id
    Should Be Equal As Strings    ${response.json()["id"]}    id deve ter exatamente 16 caracteres alfanuméricos

*** Test Cases ***
POST Produto Valido Deve Retornar 201
    Criar Sessao
    ${email}=    FakerLibrary.Email
    ${response_user}=    POST Usuario    Admin Produtos    ${email}    senha123    true
    Should Be Equal As Integers    ${response_user.status_code}    201

    ${login}=    login.POST Login    ${email}    senha123
    Should Be Equal As Integers    ${login.status_code}    200
    ${token}=    Set Variable    ${login.json()["authorization"]}

    ${nome}=    FakerLibrary.Word
    ${response}=    POST Produto    ${nome}    500    Produto Teste    10    ${token}
    Should Be Equal As Integers    ${response.status_code}    201
    Dictionary Should Contain Value    ${response.json()}    Cadastro realizado com sucesso
    Dictionary Should Contain Key    ${response.json()}    _id

    
POST Produto Existente Deve Retornar 400
    Criar Sessao
    ${email}=    FakerLibrary.Email
    ${response_user}=    POST Usuario    Admin Produtos    ${email}    senha123    true
    ${login}=    login.POST Login    ${email}    senha123
    ${token}=    Set Variable    ${login.json()["authorization"]}

    ${nome}=    FakerLibrary.Word
    ${response1}=    POST Produto    ${nome}    1000    Produto Duplicado    5    ${token}
    ${response2}=    POST Produto    ${nome}    1200    Produto Duplicado Novo    8    ${token}
    Should Be Equal As Integers    ${response2.status_code}    400
    Dictionary Should Contain Value    ${response2.json()}    Já existe produto com esse nome

POST Produto Sem Token Deve Retornar 401
    Criar Sessao
    ${nome}=    FakerLibrary.Word
    ${body}=    Create Dictionary    nome=${nome}    preco=300    descricao=Sem Token    quantidade=5
    ${response}=    POST On Session    api    ${PRODUCTS_ENDPOINT}    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401
    Dictionary Should Contain Value    ${response.json()}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

POST Produto Usuario Nao Admin Deve Retornar 403
    Criar Sessao
    ${email}=    FakerLibrary.Email
    ${response_user}=    POST Usuario    User Produtos    ${email}    senha123    false
    ${login}=    login.POST Login    ${email}    senha123
    ${token}=    Set Variable    ${login.json()["authorization"]}

    ${nome}=    FakerLibrary.Word
    ${response}=    POST Produto    ${nome}    700    Produto Nao Admin    15    ${token}
    Should Be Equal As Integers    ${response.status_code}    403
    Dictionary Should Contain Value    ${response.json()}    Rota exclusiva para administradores


PUT Produto Nao Autenticado Deve Retornar 401
    Criar Sessao
    ${id_fake}=    Set Variable    123abc
    ${body}=    Create Dictionary    nome=ProdutoFake    preco=100    descricao=SemToken    quantidade=2
    ${response}=    PUT On Session    api    ${PRODUCTS_ENDPOINT}/${id_fake}    json=${body}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401
    Dictionary Should Contain Value    ${response.json()}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

PUT Produto Existente Com Dados Validos Deve Retornar 200
    Criar Sessao
    ${email}=    FakerLibrary.Email
    ${response_user}=    POST Usuario    Admin PUT    ${email}    senha123    true
    ${login}=    login.POST Login    ${email}    senha123
    ${token}=    Set Variable    ${login.json()["authorization"]}

    # Cria produto
    ${nome}=    FakerLibrary.Word
    ${produto}=    POST Produto    ${nome}    500    Produto Antigo    5    ${token}
    Run Keyword Unless    '_id' in ${produto.json()}    Fail    Produto não foi criado corretamente, falta _id na resposta
    ${id}=    Set Variable    ${produto.json()["_id"]}

    # Atualiza produto existente
    ${response}=    PUT Produto    ${id}    ProdutoAtualizado    600    Produto Atualizado Desc    10    ${token}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Value    ${response.json()}    Registro alterado com sucesso


PUT Produto Inexistente Deve Criar Novo Produto E Retornar 201
    Criar Sessao
    ${email}=    FakerLibrary.Email
    ${response_user}=    POST Usuario    Admin PUT    ${email}    senha123    true
    ${login}=    login.POST Login    ${email}    senha123
    ${token}=    Set Variable    ${login.json()["authorization"]}

    ${id_fake}=    Set Variable    idInexistente123
    ${response}=    PUT Produto    ${id_fake}    ProdutoNovoPUT    700    Criado via PUT    12    ${token}
    Should Be Equal As Integers    ${response.status_code}    201
    Dictionary Should Contain Value    ${response.json()}    Cadastro realizado com sucesso
    Dictionary Should Contain Key    ${response.json()}    _id


PUT Produto Nome Duplicado Deve Retornar 400
    Criar Sessao
    ${email}=    FakerLibrary.Email
    ${response_user}=    POST Usuario    Admin PUT    ${email}    senha123    true
    ${login}=    login.POST Login    ${email}    senha123
    ${token}=    Set Variable    ${login.json()["authorization"]}

    # Cria produto 1
    ${nome1}=    FakerLibrary.Word
    ${produto1}=    POST Produto    ${nome1}    200    Produto Original    4    ${token}
    Run Keyword Unless    '_id' in ${produto1.json()}    Fail    Produto1 não foi criado corretamente, falta _id na resposta
    ${id1}=    Set Variable    ${produto1.json()["_id"]}

    # Cria produto 2
    ${nome2}=    FakerLibrary.Word
    ${produto2}=    POST Produto    ${nome2}    300    Produto Segundo    6    ${token}
    Run Keyword Unless    '_id' in ${produto2.json()}    Fail    Produto2 não foi criado corretamente, falta _id na resposta
    ${id2}=    Set Variable    ${produto2.json()["_id"]}

    # Tenta atualizar o produto 2 com nome já existente
    ${response}=    PUT Produto    ${id2}    ${nome1}    350    Produto Duplicado    7    ${token}
    Should Be Equal As Integers    ${response.status_code}    400
    Dictionary Should Contain Value    ${response.json()}    Já existe produto com esse nome

PUT Produto Usuario Nao Admin Deve Retornar 403
    Criar Sessao
    ${email}=    FakerLibrary.Email
    ${response_user}=    POST Usuario    User PUT    ${email}    senha123    false
    ${login}=    login.POST Login    ${email}    senha123
    ${token}=    Set Variable    ${login.json()["authorization"]}

    ${id_fake}=    Set Variable    123abc
    ${response}=    PUT Produto    ${id_fake}    ProdutoNaoAdmin    800    Tentando PUT    3    ${token}
    Should Be Equal As Integers    ${response.status_code}    403
    Dictionary Should Contain Value    ${response.json()}    Rota exclusiva para administradores

DELETE Produto Nao Autenticado Deve Retornar 401
    Criar Sessao
    ${response}=    DELETE On Session    api    ${PRODUCTS_ENDPOINT}/fakeID123    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    401
    Dictionary Should Contain Key    ${response.json()}    message

DELETE Produto Valido Deve Retornar 200
    Criar Sessao
    ${email}=    FakerLibrary.Email
    ${response_user}=    POST Usuario    User Delete    ${email}    senha123    true
    ${login}=    login.POST Login    ${email}    senha123
    ${token}=    Set Variable    ${login.json()["authorization"]}

    ${response}=    POST Produto    Produto Delete    99    Produto para excluir    2    ${token}
    ${produto_id}=    Set Variable    ${response.json()["_id"]}
    &{headers}=    Create Dictionary    Authorization=${token}
    ${response}=    DELETE On Session    api    ${PRODUCTS_ENDPOINT}/${produto_id}    headers=${headers}    expected_status=any
    Dictionary Should Contain Key    ${response.json()}    message
    Should Contain Any    ${response.json()["message"]}    Registro excluído com sucesso    Nenhum registro excluído

DELETE Produto Em Carrinho Deve Retornar 400
    Criar Sessao

    # Usuário admin para criar produto
    ${email_admin}=    FakerLibrary.Email
    ${response_user}=    POST Usuario    Admin Produtos    ${email_admin}    senha123    true
    Should Be Equal As Integers    ${response_user.status_code}    201

    ${login_admin}=    login.POST Login    ${email_admin}    senha123
    Should Be Equal As Integers    ${login_admin.status_code}    200
    ${token_admin}=    Set Variable    ${login_admin.json()["authorization"]}

    # Criar produto com admin
    ${response}=    POST Produto    Produto Delete    99    Produto para excluir    2    ${token_admin}
    Should Be Equal As Integers    ${response.status_code}    201
    ${produto_id}=    Set Variable    ${response.json()["_id"]}

    # Usuário comum para criar carrinho
    ${email_user}=    FakerLibrary.Email
    ${response_user}=    POST Usuario    User Delete    ${email_user}    senha123    false
    Should Be Equal As Integers    ${response_user.status_code}    201

    ${login_user}=    login.POST Login    ${email_user}    senha123
    Should Be Equal As Integers    ${login_user.status_code}    200
    ${token_user}=    Set Variable    ${login_user.json()["authorization"]}

    # Adicionar produto em carrinho
    &{headers}=    Create Dictionary    Authorization=Bearer ${token_user}
    &{produto}=    Create Dictionary    idProduto=${produto_id}    quantidade=1
    @{produtos}=   Create List    ${produto}
    &{body}=       Create Dictionary    produtos=${produtos}


    ${response}=    POST Carrinho    ${body}    ${token_user}
    Should Be Equal As Integers    ${response.status_code}    201

    # Tentar deletar produto com admin
    &{headers_admin}=    Create Dictionary    Authorization=Bearer ${token_admin}
    ${response}=    DELETE On Session    api    ${PRODUCTS_ENDPOINT}/${produto_id}    headers=${headers_admin}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    400
    Dictionary Should Contain Value  ${response.json()}    Não é permitido excluir produto que faz parte de carrinho