*** Settings ***
Library           SoapLibrary
Library           Collections
Library           DateTime
Library           JSONLibrary


*** Variables ***
# ipGeo
${wsdl_ip_geo}       http://ws.cdyne.com/ip2geo/ip2geo.asmx?wsdl
&{br_ip_address}     ws:ipAddress=150.162.2.1
# PostOffice
${wsdl_correios}     https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente?wsdl
&{br_postal_code}    cep=01305901
# Holidays
${wsdl_holidays}     http://services.sapo.pt/Metadata/Contract/Holiday?culture=PT?wsdl


*** Test Cases ***
ipGeo getData
    [Documentation]    Simple request to SOAP webservice and get response by tags
    Connect ipGeo API
    List ipGeo Info

ipGeo getData with XML
    [Documentation]    Request to SOAP webservice passing XML in body and response converted to dictionary
    Fill XML ip template
    Connect ipGeo API
    List ipGeo Info with XML

PostOffice_GetAddress
    [Documentation]    Request to SOAP webservice passing XML in body and response as XML object
    Fill XML po template
    Connect Post Office API
    List address information

List All City Holidays
    [Documentation]    Request to SOAP webservice and using dynamic keywords, also using log as an html table
    Connect Holidays API
    List "Fundão" Holidays "2020"
    List "Lisboa" Holidays "2021"


*** Keywords ***
Connect ipGeo API
    Create SOAP Client    ${wsdl_ip_geo}

List ipGeo Info
    comment    Since the request always needs only two arguments, they can be passed in the correct sequence as keyword arguments.
    ${response}    Call SOAP Method    ResolveIP    ${br_ip_address}[ws:ipAddress]    0
    log   ${response}
    ${country}    Get From Dictionary    ${response}    Country
    ${latitude}    Get From Dictionary    ${response}    Latitude
    ${longitude}    Get From Dictionary    ${response}    Longitude
    Log    The ip address ${br_ip_address}[ws:ipAddress] belongs to ${country} at lat: ${latitude} long: ${longitude}

Fill XML ip template
    Edit XML Request    ${CURDIR}/ip_address_template.xml    ${br_ip_address}    new_ip_address

List ipGeo Info with XML
    ${response}    Call SOAP Method With XML    ${CURDIR}/new_ip_address.xml
    ${dict_response}    Convert XML Response to Dictionary    ${response}
    log   ${dict_response}
    ${body} 	Get From Dictionary    ${dict_response}    Body
    ${resolveipresponse} 	Get From Dictionary    ${body}    ResolveIPResponse
    ${resolveipresult} 	Get From Dictionary    ${ResolveIPResponse}    ResolveIPResult
    ${country}    Get From Dictionary    ${ResolveIPResult}    Country
    ${latitude}    Get From Dictionary    ${ResolveIPResult}    Latitude
    ${longitude}    Get From Dictionary    ${ResolveIPResult}    Longitude
    Log    The ip address ${br_ip_address}[ws:ipAddress] belongs to ${country} at lat: ${latitude} long: ${longitude}

Fill XML po template
    Edit XML Request    ${CURDIR}/postal_code_template.xml    ${br_postal_code}    new_postal_code

Connect Post Office API
    Create SOAP Client    ${wsdl_correios}

List address information
    ${response}    Call SOAP Method With XML    ${CURDIR}/new_postal_code.xml
    comment    This response below is a XML object, so we can use the keyword 'Get Data From XML By Tag'
    log    ${response}
    ${postal_code}    Get Data From XML By Tag    ${response}    cep
    ${city}    Get Data From XML By Tag    ${response}    cidade
    ${street}    Get Data From XML By Tag    ${response}    end
    ${state}    Get Data From XML By Tag    ${response}    uf
    Log    the postal code ${postal_code} belongs to ${street}, ${city} - ${state}

Connect Holidays API
    Create SOAP Client    ${wsdl_holidays}

List "${city}" Holidays "${year}"
    ${city_id}    Get city Id    ${city}
    ${response}    Call SOAP Method    GetHolidaysByMunicipalityId    ${year}    ${city_id}    true
    ${len}    Get Length    ${response}
    ${table}    Set Variable    <!DOCTYPE html><html><head></head><body><table border="1">
    ${table}    Catenate    ${table}    <caption><h1>Feriados ${city} ${year}</h1></caption>
    ${table}    Catenate    ${table}    <tr><th>Data</th> <th>Nome</th> <th>Tipo</th><th>Descrição</th></tr>
    FOR    ${index}    IN RANGE    ${len}
        ${get_date}    Set Variable    ${response[${index}]['Date']}
        ${date}    Convert Date    ${get_date}    result_format=datetime
        ${table}    Catenate    ${table}    <tr><td>${date.day}/${date.month}/${date.year}</td>
        ${table}    Catenate    ${table}    <td>${response[${index}]['Name']}</td>
        ${table}    Catenate    ${table}    <td>${response[${index}]['Type']}</td>
        ${table}    Catenate    ${table}    <td>${response[${index}]['Description']}</td></tr>
    END
    ${table}    Catenate    ${table}    </table></body></html>
    log    ${table}    html=True

Get city Id
    [Arguments]    ${city}
    ${response}    Call SOAP Method    GetLocalHolidays    2020
    ${len}    Get Length    ${response}
    FOR    ${index}    IN RANGE    ${len}
        ${id}    Set Variable    ${response[${index}]['Municipality']['Id']}
        ${name}    Set Variable    ${response[${index}]['Municipality']['Name']}
        ${city_id}    Set Variable If    '${name}'=='${city}'    ${id}
        Exit For Loop If    '${name}'=='${city}'
    END
    [Return]    ${city_id}