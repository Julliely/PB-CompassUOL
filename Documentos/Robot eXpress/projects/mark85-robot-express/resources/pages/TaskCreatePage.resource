*** Settings ***
Documentation    Ações e elementos da página do cadastro

Library    Browser

*** Keywords ***
Submit task from
    [Arguments]    ${task}

    Fill Text    css=input[placeholder$=tarefa]    ${task}[name]

    ${tags_element}    Set Variable    css=input[name=tags]

    FOR    ${tags}    IN    @{task}[tags]
        Fill Text    ${tags_element}    ${tags}
        Sleep    1
        Press Keys   ${tags_element}    Enter
    END

    Fill Text    css=input[name=tags]    ${task}[tags]

    Click    css=button >> text=Cadastrar
