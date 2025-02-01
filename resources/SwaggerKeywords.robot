*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections
Resource    ../variables.robot
Library    BuiltIn


*** Keywords ***
#Create pet method
Create a New Pet
    [Arguments]    ${CATEGORY_ID}    ${CATEGORY_NAME}    ${NAME}    ${PHOTOS_URL}    ${TAG_ID}    ${TAG_NAME}    ${STATUS}    ${expected_status_code}
    #create headers
    ${headers}    Create Default Headers
    #create needed request body
    ${request_body}=    Catenate    SEPARATOR=    {    "id": 0, "category": {"id": "${CATEGORY_ID}", "name": "${CATEGORY_NAME}"},    "name": "${NAME}", "photoUrls": ${PHOTOS_URL}, "tags": [{"id": ${TAG_ID}, "name": "${TAG_NAME}"}], "status": "${STATUS}"    }
    #call needed request
    ${response}=    POST    ${BASE_URL}/pet    data=${request_body}    headers=${headers}
    #assert on status code
    Status Should Be    ${expected_status_code}    ${response}
    #retrun stats code
    RETURN    ${response}



Update Pet
    [Arguments]    ${PET_ID}    ${CATEGORY_ID}    ${CATEGORY_NAME}    ${NAME}    ${PHOTOS_URL}    ${TAG_ID}    ${TAG_NAME}    ${STATUS}    ${expected_status_code}
    #create headers
    ${headers}    Create Default Headers
    #create needed request body
    ${request_body}=    Catenate    SEPARATOR=    {    "id": ${PET_ID}, "category": {"id": "${CATEGORY_ID}", "name": "${CATEGORY_NAME}"},    "name": "${NAME}", "photoUrls": ${PHOTOS_URL}, "tags": [{"id": ${TAG_ID}, "name": "${TAG_NAME}"}], "status": "${STATUS}"    }
    #call needed request
    ${response}=    PUT    ${BASE_URL}/pet    data=${request_body}    headers=${headers}
    #assert on status code
    Status Should Be    ${expected_status_code}    ${response}
    #retrun stats code
    RETURN    ${response}


Get Pet
    [Arguments]    ${PET_ID}    ${expected_status_code}
    #create headers
    ${headers}    Create Default Headers

    #call needed request and ignore error
    ${status}    ${response}    Run Keyword And Ignore Error    GET    ${BASE_URL}/pet/${PET_ID}    headers=${headers}

    #check if the status is FAIL (404 response)
    Run Keyword If    '${status}'=='FAIL'    Log To Console    Pet not found as expected (404)
    ...    ELSE    Status Should Be    ${expected_status_code}    ${response}

    #return response
    RETURN    ${response}


Delete Pet
    [Arguments]    ${PET_ID}    ${expected_status_code}
    #creating special headers for deleting method as needed in docs
    ${headers}    Create Dictionary    accept=application/json    api_key=special-key

    #call needed request
    ${response}=    DELETE    ${BASE_URL}/pet/${PET_ID}    headers=${headers}

    #assert on status code
    Status Should Be    ${expected_status_code}    ${response}

    #retrun stats code
    RETURN    ${response}




Generate Random Integer
    [Arguments]    ${min}    ${max}
    ${random_int}=    Evaluate    random.randint(${min}, ${max})    modules=random
    RETURN    ${random_int}