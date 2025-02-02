*** Settings ***
#Library    RequestsLibrary
#Library    JSONLibrary
Library    Collections
*** Variables ***
${SWAGGER_BASE_URL}       https://petstore.swagger.io/v2
*** Keywords ***

Create Default Headers
    [Documentation]    Creates default headers dictionary
    ${DEFAULT_HEADERS}=    Create Dictionary    accept=application/json    Content-Type=application/json
    RETURN    ${DEFAULT_HEADERS}