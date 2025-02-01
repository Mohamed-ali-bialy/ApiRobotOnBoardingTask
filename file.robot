*** Settings ***
Library           RequestsLibrary

*** Variables ***
${BASE_URL}       https://petstore.swagger.io/v2
${DEFAULT_HEADERS}    accept=application/json    Content-Type=application/json

*** Test Cases ***

Quick Get Request Test
    ${response}=    GET    ${BASE_URL}/pet/9223372036854775807
    Log to console    ${response.status_code}
    Log to console    ${response.content}
    Log to console    ${response.json()}


Quick post Request Test
    ${response}=    POST    https://petstore.swagger.io/v2/pet    data
    Log to console    ${response.status_code}
    Log to console    ${response.content}
    Log to console    ${response.json()}
