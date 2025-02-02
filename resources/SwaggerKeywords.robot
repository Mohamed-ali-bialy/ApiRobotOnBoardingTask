*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections
Resource          ../resources/variables.robot
Library    String



*** Keywords ***
# Create pet method
Create a New Pet
    [Arguments]    ${pet_data}    ${expected_status_code}

    #create headers
    ${headers}    Create Default Headers

    #create needed request body
    ${request_body}=    Catenate    SEPARATOR=    {    "id": 0, "category": {"id": "${pet_data['category_id']}", "name": "${pet_data['category_name']}"},    "name": "${pet_data['name']}", "photoUrls": ${pet_data['photos_url']}, "tags": [{"id": ${pet_data['tag_id']}, "name": "${pet_data['tag_name']}"}], "status": "${pet_data['status']}"    }
    #call needed request
    ${response}=    POST    ${SWAGGER_BASE_URL}/pet    data=${request_body}    headers=${headers}

    #assert on status code as expected
    Status Should Be    ${expected_status_code}    ${response}

    #retrun response
    RETURN    ${response}


# update pet data with PUT method
Update Pet
    [Arguments]    ${pet_id}    ${updated_pet_data}    ${expected_status_code}

    #create headers
    ${headers}    Create Default Headers

    #create needed request body
    ${request_body}=    Catenate    SEPARATOR=    {    "id": ${pet_id}, "category": {"id": "${updated_pet_data['category_id']}", "name": "${updated_pet_data['category_name']}"},    "name": "${updated_pet_data['name']}", "photoUrls": ${updated_pet_data['photos_url']}, "tags": [{"id": ${updated_pet_data['tag_id']}, "name": "${updated_pet_data['tag_name']}"}], "status": "${updated_pet_data['status']}"    }
    #call needed request
    ${response}=    PUT    ${SWAGGER_BASE_URL}/pet    data=${request_body}    headers=${headers}

    #assert on status code as expected
    Status Should Be    ${expected_status_code}    ${response}

    #retrun response
    RETURN    ${response}

# GET pet by ID
Get Pet
    [Arguments]    ${PET_ID}    ${expected_status_code}

    #create headers
    ${headers}    Create Default Headers

    #call needed request and ignore error
    ${status}    ${response}    Run Keyword And Ignore Error    GET    ${SWAGGER_BASE_URL}/pet/${PET_ID}    headers=${headers}

    #check if the status is FAIL (404 response)
    Run Keyword If    '${status}'=='FAIL'    Log To Console    Pet not found as expected (404)
    ...    ELSE    Status Should Be    ${expected_status_code}    ${response}

    #return response
    RETURN    ${response}

# DELETE pet by the ID
Delete Pet
    [Arguments]    ${PET_ID}    ${expected_status_code}

    #creating special headers for deleting method as needed in docs
    ${headers}    Create Dictionary    accept=application/json    api_key=special-key

    #call needed request
    ${response}=    DELETE    ${SWAGGER_BASE_URL}/pet/${PET_ID}    headers=${headers}

    #assert on status code
    Status Should Be    ${expected_status_code}    ${response}

    #return response
    RETURN    ${response}



# generate random Integer Number
Generate Random Integer
    [Arguments]    ${min}    ${max}
    ${random_int}=    Evaluate    random.randint(${min}, ${max})    modules=random
    RETURN    ${random_int}


Generate Pet Data
    ${category_id}=    Generate Random Integer    1    100
    ${category_name}=    Generate Random String    10    [LETTERS]
    ${name}=    Generate Random String    8    [LETTERS]
    ${photo_number_1}=    Generate Random Integer    1    100
    ${photo_number_2}=    Generate Random Integer    1    100
    ${tag_id}=    Generate Random Integer    1    50
    ${tag_name}=    Generate Random String    12    [LETTERS]
    ${status}=    Generate Random String    10    [LETTERS]
    ${photos_url}=    Set Variable    ["photo/${photo_number_1}","photo/${photo_number_2}"]
    ${pet_data}=    Create Dictionary    category_id=${category_id}    category_name=${category_name}    name=${name}    photos_url=${photos_url}    tag_id=${tag_id}    tag_name=${tag_name}    status=${status}
    RETURN    ${pet_data}