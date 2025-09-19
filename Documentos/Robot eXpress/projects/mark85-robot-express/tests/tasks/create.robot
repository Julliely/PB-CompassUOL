*** Settings ***
Documentation    Cenários de cadastro de tarefas

Library    JSONLibrary

Resource    ../../resources/base.resource

Test Setup    Start Session
Test Teardown    Take Screenshot

*** Test Cases ***
Deve poder cadastrar uma nova tarefa

    ${data}    Get fixture    tasks     create

    Clean user from database    ${data}[user][email]
    Insert user from database    ${data}[user]

    Submit login from    ${data}[user]
    User should be logged in     ${data}[user][name]
    
    Go to task from
    Submit task from    ${data}[task]
    Taks should be registered    ${data}[task][name]
    
Não deve cadastrar tarefa com nome duplicado
    [Tags]    dup

    ${data}    Get fixture    tasks    duplicate

    Clean user from database    ${data}[user][email]
    Insert user from database    ${data}[user]

    POST On Session     ${data}[user]

    POST a new tasks    ${data}[task]

   # Submit login from    ${data}[user]
   # User should be logged in     ${data}[user][name]

   # Go to task from
   # Submit task from    ${data}[task]

   # Go to task from
   # Submit task from    ${data}[task]

   # Notice should be    Oops! Tarefa duplicada.