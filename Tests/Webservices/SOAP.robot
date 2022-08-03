*** Settings ***
Documentation     Test suite for demonstration only, using robotframework==5.0.1, robotframework-soaplibrary==1.0
...    and robotframework-jsonlibrary==0.4.1
Library           Collections
Library           DateTime
Library           SoapLibrary
Library           JSONLibrary


*** Variables ***
# ipGeo
${WSDL_IP_GEO}       http://ws.cdyne.com/ip2geo/ip2geo.asmx?wsdl
&{BR_IP_ADDRESS}     ws:ipAddress=150.162.2.1
# PostOffice
${WSDL_CORREIOS}     https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente?wsdl
&{BR_POSTAL_CODE}    cep=01305901
# Holidays
${WSDL_HOLIDAYS}     http://services.sapo.pt/Metadata/Contract/Holiday?culture=PT?wsdl


*** Test Cases ***
ipGeo getData
    [Documentation]    Simple request to SOAP webservice and get response by tags
    [Tags]    Webservice    SOAP
    Connect ipGeo API
    List ipGeo Info

ipGeo getData with XML
    [Documentation]    Request to SOAP webservice passing XML in body and response converted to dictionary
    [Tags]    Webservice    SOAP
    Fill XML ip template
    Connect ipGeo API
    List ipGeo Info with XML

PostOffice GetAddress
    [Documentation]    Request to SOAP webservice passing XML in body and response as XML object
    [Tags]    Webservice    SOAP
    Fill XML po template
    Connect Post Office API
    List address information

List All City Holidays
    [Documentation]    Request to SOAP webservice and using dynamic keywords, also using log as an html table
    [Tags]    Webservice    SOAP
    Connect Holidays API
    List "Fundão" Holidays "2022"
    List "Lisboa" Holidays "2023"


*** Keywords ***
Connect ipGeo API
    Create SOAP Client    ${WSDL_IP_GEO}

List ipGeo Info
    comment    Since the request always needs only two arguments, they can be passed in the correct
    ...    sequence as keyword arguments.
    ${RESPONSE}    Call SOAP Method    ResolveIP    ${BR_IP_ADDRESS}[ws:ipAddress]    0
    log   ${RESPONSE}
    ${COUNTRY}    Get From Dictionary    ${RESPONSE}    Country
    ${LATITUDE}    Get From Dictionary    ${RESPONSE}    Latitude
    ${LONGITUDE}    Get From Dictionary    ${RESPONSE}    Longitude
    Log    The ip address ${BR_IP_ADDRESS}[ws:ipAddress] belongs to ${COUNTRY} at lat: ${LATITUDE} long: ${LONGITUDE}

Fill XML ip template
    Edit XML Request    ${CURDIR}/ip_address_template.xml    ${BR_IP_ADDRESS}    new_ip_address

List ipGeo Info with XML
    ${RESPONSE}    Call SOAP Method With XML    ${CURDIR}/new_ip_address.xml
    ${DICT_RESPONSE}    Convert XML Response to Dictionary    ${RESPONSE}
    log   ${DICT_RESPONSE}
    ${BODY} 	Get From Dictionary    ${DICT_RESPONSE}    Body
    ${RESOLVEIPRESPONSE} 	Get From Dictionary    ${BODY}    ResolveIPResponse
    ${RESOLVEIPRESULT} 	Get From Dictionary    ${RESOLVEIPRESPONSE}    ResolveIPResult
    ${COUNTRY}    Get From Dictionary    ${RESOLVEIPRESULT}    Country
    ${LATITUDE}    Get From Dictionary    ${RESOLVEIPRESULT}    Latitude
    ${LONGITUDE}    Get From Dictionary    ${RESOLVEIPRESULT}    Longitude
    Log    The ip address ${BR_IP_ADDRESS}[ws:ipAddress] belongs to ${COUNTRY} at lat: ${LATITUDE} long: ${LONGITUDE}

Fill XML po template
    Edit XML Request    ${CURDIR}/postal_code_template.xml    ${BR_POSTAL_CODE}    new_postal_code

Connect Post Office API
    Create SOAP Client    ${WSDL_CORREIOS}

List address information
    ${RESPONSE}    Call SOAP Method With XML    ${CURDIR}/new_postal_code.xml
    comment    This response below is a XML object, so we can use the keyword 'Get Data From XML By Tag'
    log    ${RESPONSE}
    ${POSTAL_CODE}    Get Data From XML By Tag    ${RESPONSE}    cep
    ${CITY}    Get Data From XML By Tag    ${RESPONSE}    cidade
    ${STREET}    Get Data From XML By Tag    ${RESPONSE}    end
    ${STATE}    Get Data From XML By Tag    ${RESPONSE}    uf
    Log    the postal code ${POSTAL_CODE} belongs to ${STREET}, ${CITY} - ${STATE}

Connect Holidays API
    Create SOAP Client    ${WSDL_HOLIDAYS}

List "${CITY}" Holidays "${YEAR}"
    ${CITY_ID}    Get city Id    ${CITY}
    ${RESPONSE}    Call SOAP Method    GetHolidaysByMunicipalityId    ${YEAR}    ${CITY_ID}    true
    ${LEN}    Get Length    ${RESPONSE}
    ${TABLE}    Set Variable    <!DOCTYPE html><html><head></head><body><table border="1">
    ${TABLE}    Catenate    ${TABLE}    <caption><h1>Feriados ${CITY} ${YEAR}</h1></caption>
    ${TABLE}    Catenate    ${TABLE}    <tr><th>Data</th> <th>Nome</th> <th>Tipo</th><th>Descrição</th></tr>
    FOR    ${INDEX}    IN RANGE    ${LEN}
        ${GET_DATE}    Set Variable    ${RESPONSE[${INDEX}]['Date']}
        ${DATE}    Convert Date    ${GET_DATE}    result_format=datetime
        ${TABLE}    Catenate    ${TABLE}    <tr><td>${DATE.day}/${DATE.month}/${DATE.year}</td>
        ${TABLE}    Catenate    ${TABLE}    <td>${RESPONSE[${INDEX}]['Name']}</td>
        ${TABLE}    Catenate    ${TABLE}    <td>${RESPONSE[${INDEX}]['Type']}</td>
        ${TABLE}    Catenate    ${TABLE}    <td>${RESPONSE[${INDEX}]['Description']}</td></tr>
    END
    ${TABLE}    Catenate    ${TABLE}    </table></body></html>
    log    ${TABLE}    html=True

Get city Id
    [Arguments]    ${CITY}
    ${RESPONSE}    Call SOAP Method    GetLocalHolidays    2020
    ${LEN}    Get Length    ${RESPONSE}
    FOR    ${INDEX}    IN RANGE    ${LEN}
        ${ID}    Set Variable    ${RESPONSE[${INDEX}]['Municipality']['Id']}
        ${NAME}    Set Variable    ${RESPONSE[${INDEX}]['Municipality']['Name']}
        IF    '${NAME}'=='${CITY}'
            ${CITY_ID}    Set Variable    ${ID}
            BREAK
        END
    END
    RETURN    ${CITY_ID}
