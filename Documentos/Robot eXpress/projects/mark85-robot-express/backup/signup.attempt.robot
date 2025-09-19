*** Settings ***
Documentation    Cénario de tentativa de cadastro com senha muito curta

Resource    ../resources/base.resource
Test Template    Short password

Test Setup    Start Session
Test Teardown    Take Screenshot

*** Test Cases ***
Nao deve cadastrar com senha de 1 digito     1
Nao deve cadastrar com senha de 2 digitos    12
Nao deve cadastrar com senha de 3 digitos    123
Nao deve cadastrar com senha de 4 digitos    1234
Nao deve cadastrar com senha de 5 digitos    12345


*** Keywords ***
Short password
    [Arguments]    ${short_pass}

     ${user}    Create Dictionary    
    ...    name=senha curta
    ...    email=senhacurta@gmail.com
    ...    password=${short_pass}
    
    Go to signup page
    Submit signup from    ${user}

    Alert should be    Informe uma senha com pelo menos 6 digitos