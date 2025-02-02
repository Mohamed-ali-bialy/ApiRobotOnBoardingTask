*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Resource          ../resources/SwaggerKeywords.robot
Library    String

*** Variables ***
${expected_status_code}    200

*** Test Cases ***
create and update pet test
    # Generate random data for the create test
    ${random_category_id}=    Generate Random Integer    1    100
    ${random_category_name}=    Generate Random String    10    [LETTERS]
    ${random_name}=    Generate Random String    8    [LETTERS]
    ${random_photo_number_1}=    Generate Random Integer    1    100
    ${random_photo_number_2}=    Generate Random Integer    1    100
    ${random_tag_id}=    Generate Random Integer    1    50
    ${random_tag_name}=    Generate Random String    12    [LETTERS]
    ${random_status}=    Generate Random String    10    [LETTERS]
    ${PHOTOS_URL}=    Set Variable    ["photo/${random_photo_number_1}","photo/${random_photo_number_2}"]

    Log to Console    Random Category ID: ${random_category_id}
    Log to Console    Random Category Name: ${random_category_name}
    Log to Console    Random Name: ${random_name}
    Log to Console    Random Photo Number 1: ${random_photo_number_1}
    Log to Console    Random Photo Number 2: ${random_photo_number_2}
    Log to Console    Random Tag ID: ${random_tag_id}
    Log to Console    Random Tag Name: ${random_tag_name}
    Log to Console    Random Status: ${random_status}
    Log to Console    Photos URL: ${PHOTOS_URL}

    ${response}    Create a New Pet    ${random_category_id}    ${random_category_name}    ${random_name}    ${PHOTOS_URL}    ${random_tag_id}    ${random_tag_name}    ${random_status}    ${expected_status_code}
    Log to console    ${response}
    Log to console    ${response.json()}
    ${CREATED_PET_ID}=    Set variable    ${response.json()['id']}

    ${expected_photos}=    Evaluate    json.loads('''${PHOTOS_URL}''')    json

    Should be equal as strings    ${response.json()}[category][id]    ${random_category_id}
    Should be equal as strings    ${response.json()}[category][name]    ${random_category_name}
    Should be equal as strings    ${response.json()['name']}    ${random_name}
    Lists Should Be Equal    ${response.json()['photoUrls']}    ${expected_photos}
    Should be equal as strings    ${response.json()}[tags][0][id]    ${random_tag_id}
    Should be equal as strings    ${response.json()}[tags][0][name]    ${random_tag_name}
    Should be equal as strings    ${response.json()}[status]    ${random_status}
    Should be equal as strings    ${response.status_code}    ${expected_status_code}

    # Generate random data for the update test
    ${updated_category_id}=    Generate Random Integer    1    100
    ${updated_category_name}=    Generate Random String    10    [LETTERS]
    ${updated_name}=    Generate Random String    8    [LETTERS]
    ${updated_photo_number_1}=    Generate Random Integer    1    100
    ${updated_photo_number_2}=    Generate Random Integer    1    100
    ${updated_tag_id}=    Generate Random Integer    1    50
    ${updated_tag_name}=    Generate Random String    12    [LETTERS]
    ${updated_status}=    Generate Random String    10    [LETTERS]
    ${UPDATED_PHOTOS_URL}=    Set Variable    ["photo/${updated_photo_number_1}","photo/${updated_photo_number_2}"]

    Log to Console    Updated Category ID: ${updated_category_id}
    Log to Console    Updated Category Name: ${updated_category_name}
    Log to Console    Updated Name: ${updated_name}
    Log to Console    Updated Photo Number 1: ${updated_photo_number_1}
    Log to Console    Updated Photo Number 2: ${updated_photo_number_2}
    Log to Console    Updated Tag ID: ${updated_tag_id}
    Log to Console    Updated Tag Name: ${updated_tag_name}
    Log to Console    Updated Status: ${updated_status}
    Log to Console    Updated Photos URL: ${UPDATED_PHOTOS_URL}

    ${response}    Update Pet    ${CREATED_PET_ID}    ${updated_category_id}    ${updated_category_name}    ${updated_name}    ${UPDATED_PHOTOS_URL}    ${updated_tag_id}    ${updated_tag_name}    ${updated_status}    ${expected_status_code}
    Log to console    ${response}
    Log to console    ${response.json()}

    ${expected_updated_photos}=    Evaluate    json.loads('''${UPDATED_PHOTOS_URL}''')    json

    Should be equal as strings    ${response.json()}[category][id]    ${updated_category_id}
    Should be equal as strings    ${response.json()}[category][name]    ${updated_category_name}
    Should be equal as strings    ${response.json()['name']}    ${updated_name}
    Lists Should Be Equal    ${response.json()['photoUrls']}    ${expected_updated_photos}
    Should be equal as strings    ${response.json()}[tags][0][id]    ${updated_tag_id}
    Should be equal as strings    ${response.json()}[tags][0][name]    ${updated_tag_name}
    Should be equal as strings    ${response.json()}[status]    ${updated_status}
    Should be equal as strings    ${response.status_code}    ${expected_status_code}

    ${response}    Get Pet    ${CREATED_PET_ID}    ${expected_status_code}
    Log to console    ${response}
    Log to console    ${response.json()}

    ${expected_updated_photos}=    Evaluate    json.loads('''${UPDATED_PHOTOS_URL}''')    json

    Should be equal as strings    ${response.json()}[category][id]    ${updated_category_id}
    Should be equal as strings    ${response.json()}[category][name]    ${updated_category_name}
    Should be equal as strings    ${response.json()['name']}    ${updated_name}
    Lists Should Be Equal    ${response.json()['photoUrls']}    ${expected_updated_photos}
    Should be equal as strings    ${response.json()}[tags][0][id]    ${updated_tag_id}
    Should be equal as strings    ${response.json()}[tags][0][name]    ${updated_tag_name}
    Should be equal as strings    ${response.json()}[status]    ${updated_status}
    Should be equal as strings    ${response.status_code}    ${expected_status_code}


    ${response}    Delete Pet    ${CREATED_PET_ID}    ${expected_status_code}
    Log to console    ${response}
    Log to console    ${response.json()}
    Should be equal as strings    ${response.status_code}    ${expected_status_code}


    ${response}    Get Pet    ${CREATED_PET_ID}    404
    Log to console    response in LOG: ${response}
    #Should be equal as strings    ${response.status_code}    404

    #Log to console    ${response.json()}

