*** Settings ***

Library    libs/database.py
Library    Browser
Library    JSONLibrary

Resource    env.resource

Resource    pages/SignupPage.resource
Resource    pages/LoginPage.resource
Resource    pages/TaskCreatePage.resource
Resource    pages/TasksPage.resource

Resource    pages/components/Notice.resource
Resource    pages/components/Header.resource
Resource    pages/components/Alert.resource

Resource    service.resource


*** Keywords ***
Start Session

    New Browser    browser=chromium    headless=False
    New Page    ${BASE_URL}

# Template
Short password
    [Arguments]    ${short_pass}

    ${user}    Create Dictionary    
    ...    name=senha curta
    ...    email=senhacurta@gmail.com
    ...    password=${short_pass}
    
    Go to signup page
    Submit signup from    ${user}

    Alert should be    Informe uma senha com pelo menos 6 digitos

# Helpers
Get fixture
    [Arguments]    ${file_name}    ${scenario}

    ${data}    Load Json From File    
    ...    ${EXECDIR}/resources/fixtures/${file_name}.json
    ...    encoding=utf-8
    
    [Return]    ${data}[${scenario}]