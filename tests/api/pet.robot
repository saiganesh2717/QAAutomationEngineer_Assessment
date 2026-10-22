*** Settings ***
Documentation     Part B - CRUD tests against the public Swagger Petstore (https://petstore.swagger.io/v2).
Library           RequestsLibrary
Library           Collections
Suite Setup       Prepare Test Data And Session

*** Variables ***
${API_URL}    https://petstore.swagger.io/v2

*** Test Cases ***
4. Create A Resource
    ${body}=    Build Pet Body    ${INITIAL_NAME}
    ${resp}=    POST On Session    petstore    /pet    json=${body}
    Status Should Be    200    ${resp}
    Should Be Equal As Integers    ${resp.json()}[id]    ${PET_ID}
    Should Be Equal As Strings     ${resp.json()}[name]    ${INITIAL_NAME}

5. Read And Verify
    # Public Petstore is eventually consistent, so retry for a short while.
    ${resp}=    Wait Until Keyword Succeeds    20s    2s    Get Pet    ${PET_ID}
    Should Be Equal As Integers    ${resp.json()}[id]    ${PET_ID}
    Should Be Equal As Strings     ${resp.json()}[name]    ${INITIAL_NAME}
    Should Be Equal As Strings     ${resp.json()}[status]    available

6. Update A Resource
    ${body}=    Build Pet Body    ${UPDATED_NAME}
    ${resp}=    PUT On Session    petstore    /pet    json=${body}
    Status Should Be    200    ${resp}
    Should Be Equal As Strings    ${resp.json()}[name]    ${UPDATED_NAME}
    Wait Until Keyword Succeeds    20s    2s    Pet Name Should Be    ${UPDATED_NAME}

7. Delete And Confirm
    ${resp}=    DELETE On Session    petstore    /pet/${PET_ID}
    Status Should Be    200    ${resp}
    ${missing}=    Wait Until Keyword Succeeds    20s    2s    Pet Should Not Exist
    Status Should Be    404    ${missing}
    Should Contain    ${missing.json()}[message]    not found    ignore_case=True

*** Keywords ***
Prepare Test Data And Session
    ${ts}=    Evaluate    int(time.time() * 1000)    modules=time
    Set Suite Variable    ${PET_ID}           ${ts}
    Set Suite Variable    ${INITIAL_NAME}     TestPet-${ts}
    Set Suite Variable    ${UPDATED_NAME}     UpdatedPet-${ts}
    Create Session    petstore    ${API_URL}    headers=${{ {"Accept": "application/json"} }}

Build Pet Body
    [Arguments]    ${name}
    ${category}=    Create Dictionary    id=${1}    name=Dogs
    ${tag}=         Create Dictionary    id=${1}    name=automation
    ${photos}=      Create List          https://example.com/photo.jpg
    ${tags}=        Create List          ${tag}
    ${body}=        Create Dictionary
    ...    id=${PET_ID}    category=${category}    name=${name}
    ...    photoUrls=${photos}    tags=${tags}    status=available
    RETURN    ${body}

Get Pet
    [Arguments]    ${id}
    ${resp}=    GET On Session    petstore    /pet/${id}
    RETURN    ${resp}

Pet Name Should Be
    [Arguments]    ${expected}
    ${resp}=    Get Pet    ${PET_ID}
    Should Be Equal As Strings    ${resp.json()}[name]    ${expected}

Pet Should Not Exist
    ${resp}=    GET On Session    petstore    /pet/${PET_ID}    expected_status=404
    RETURN    ${resp}
