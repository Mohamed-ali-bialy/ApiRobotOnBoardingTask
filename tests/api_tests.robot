*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Resource          ../resources/SwaggerKeywords.robot
Library    String

*** Variables ***
${expected_status_code}    200
${not_found_status_code}    404

*** Test Cases ***

Create Pet Test
#Test for creating pet

    #generate random data for creating pet
    ${pet_data}=    Generate Pet Data
    #call create pet method
    ${create_response}    Create a New Pet    ${pet_data}    ${expected_status_code}
    #get created pet id
    ${created_pet_id}=    Set variable    ${create_response.json()['id']}
    #set pet id as a suite variable
    Set Suite Variable    ${created_pet_id}
    # assert that created data is the same with pet data
    Assert Pet Data    ${create_response}    ${pet_data}    create

Update Pet Test
#Test for updating pet

    #create data for updating and set it as a suite variable
    ${updated_pet_data}=    Generate Pet Data
    Set Suite Variable    ${updated_pet_data}
    #call update pet method
    ${update_response}    Update Pet    ${created_pet_id}    ${updated_pet_data}    ${expected_status_code}
    #assert on updated data
    Assert Pet Data    ${update_response}    ${updated_pet_data}    update

Get Pet Test
#Test for get pet By ID

    #call get pet by Id
    ${get_response}    Get Pet    ${created_pet_id}    ${expected_status_code}
    #asset on get data
    Assert Pet Data    ${get_response}    ${updated_pet_data}    get

Delete Pet Test
#Test for deleting pet by Id

    #call delete pet by ID
    ${delete_response}    Delete Pet    ${created_pet_id}    ${expected_status_code}
    #assert on status code in delete method
    Should be equal as strings    ${delete_response.status_code}    ${expected_status_code}

    # call get pet after delete should rerun 404 bad request (not found)
    ${get_after_delete_response}    Get Pet    ${created_pet_id}    ${not_found_status_code}

*** Keywords ***
Assert Pet Data
    [Arguments]    ${response}    ${pet_data}    ${method}
    ${expected_photos}=    Evaluate    json.loads('''${pet_data['photos_url']}''')    json

    Should be equal as strings    ${response.json()}[category][id]    ${pet_data['category_id']}    msg=Category ID in the response does not match the expected value in ${method}.
    Should be equal as strings    ${response.json()}[category][name]    ${pet_data['category_name']}    msg=Category Name in the response does not match the expected value in ${method}.
    Should be equal as strings    ${response.json()['name']}    ${pet_data['name']}    msg=Pet Name in the response does not match the expected value in ${method}.
    Lists Should Be Equal    ${response.json()['photoUrls']}    ${expected_photos}    msg=Photo URLs in the response do not match the expected values in ${method}.
    Should be equal as strings    ${response.json()}[tags][0][id]    ${pet_data['tag_id']}    msg=Tag ID in the response does not match the expected value in ${method}.
    Should be equal as strings    ${response.json()}[tags][0][name]    ${pet_data['tag_name']}    msg=Tag Name in the response does not match the expected value in ${method}.
    Should be equal as strings    ${response.json()}[status]    ${pet_data['status']}    msg=Pet Status in the response does not match the expected value in ${method}.
    Should be equal as strings    ${response.status_code}    ${expected_status_code}    msg=Response status code does not match the expected value in ${method}.