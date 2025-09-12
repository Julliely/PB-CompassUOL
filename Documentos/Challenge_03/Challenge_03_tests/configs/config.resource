*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}            https://compassuol.serverest.dev
${USERS_ENDPOINT}      /usuarios
${PRODUCTS_ENDPOINT}   /produtos
${LOGIN_ENDPOINT}      /login
${CARRINHOS_ENDPOINT}  /carrinhos

${USUARIO_EMAIL}       fulano@qa.com
${USUARIO_SENHA}       teste

*** Keywords ***
Criar Sessao
    Create Session    api    ${BASE_URL}    verify=False