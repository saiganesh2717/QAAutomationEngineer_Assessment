*** Settings ***
Documentation     Part A - UI automation against the public Demo Web Shop.
Resource          ../../resources/common.resource
Suite Setup       Open Shop Browser
Suite Teardown    Close All Browsers
Test Setup        Open Home Page

*** Variables ***
@{MENU_ITEMS}     Books    Computers    Electronics    Apparel & Shoes    Digital downloads    Jewelry    Gift Cards
${SEARCH_TERM}    laptop

*** Test Cases ***
1. Home Page Verification
    Title Should Be    Demo Web Shop
    Element Should Be Visible    css:.header-logo a
    Element Should Be Visible    id:small-searchterms
    FOR    ${item}    IN    @{MENU_ITEMS}
        Element Should Be Visible
        ...    xpath:(//ul[contains(@class,'top-menu')]/li/a[normalize-space()='${item}'])[1]
    END
    Capture Full Page Screenshot    01-home-page.png

2. Category Navigation
    Click Element    xpath:(//ul[contains(@class,'top-menu')]/li/a[normalize-space()='Computers'])[1]
    Wait Until Location Contains    /computers
    Element Should Contain    css:.page-title h1    Computers
    ${count}=    Get Element Count    css:.sub-category-grid .sub-category-item
    Should Be Equal As Integers    ${count}    3
    FOR    ${sub}    IN    Desktops    Notebooks    Accessories
        Element Should Be Visible
        ...    xpath://div[contains(@class,'sub-category-item')]//a[normalize-space()='${sub}']
    END
    Capture Full Page Screenshot    02-category-computers.png

3. Search Functionality
    Input Text    id:small-searchterms    ${SEARCH_TERM}
    Press Keys    id:small-searchterms    ENTER
    Wait Until Location Contains    search?q=${SEARCH_TERM}
    Element Should Contain    css:.page-title h1    Search
    Wait Until Element Is Visible    css:.search-results .product-item
    ${titles}=    Get WebElements    css:.search-results .product-item .product-title
    Should Not Be Empty    ${titles}
    FOR    ${el}    IN    @{titles}
        ${text}=    Get Text    ${el}
        Should Contain    ${text}    ${SEARCH_TERM}    ignore_case=True
    END
    Capture Full Page Screenshot    03-search-results.png
