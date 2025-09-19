*** Settings ***
Documentation    Online

Resource    ../resources/base.resource

Library    Browser

*** Test Cases ***
Webapp deve estar online 

    Start Session
    Get Title    equal    Mark85 by QAx
