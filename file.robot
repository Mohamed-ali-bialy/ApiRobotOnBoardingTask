*** Settings ***
Library               RequestsLibrary

*** Test Cases ***

Quick Get Request Test
    ${response}=    GET  https://petstore.swagger.io/v2/pet/9223372036854097884
    Log to console    ${response.status_code}
    Log to console    ${response.content}
    Log to console    ${response.json()}

