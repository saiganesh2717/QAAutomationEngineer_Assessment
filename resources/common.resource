*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BASE_URL}          https://demowebshop.tricentis.com
${SCREENSHOT_DIR}    ${CURDIR}/../verification
${BROWSER_OPTIONS}   add_argument("--headless=new");add_argument("--window-size=1366,900");add_argument("--no-sandbox");add_argument("--disable-gpu")

*** Keywords ***
Open Shop Browser
    Open Browser    ${BASE_URL}    chrome    options=${BROWSER_OPTIONS}
    Set Window Size    1366    900

Open Home Page
    Go To    ${BASE_URL}
    Wait Until Element Is Visible    css:.header-logo a

Capture Full Page Screenshot
    [Documentation]    SeleniumLibrary only captures the viewport, so resize the window to the page height first.
    [Arguments]    ${filename}
    ${height}=    Execute Javascript    return Math.max(document.body.scrollHeight, document.documentElement.scrollHeight)
    ${tall}=      Evaluate    int(${height}) + 150
    Set Window Size    1366    ${tall}
    Capture Page Screenshot    ${SCREENSHOT_DIR}/${filename}
    Set Window Size    1366    900
