Feature: XH_EQUIP.tst

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}

    * def request_2 = read('Test_4_RecordContractRequest.json')

  @P2K @XH_EQUIP
  Scenario: XH_EQUIP
    * def TermID = "XH_EQUIP"
    * def AccountNumber = request_2.customerIdentifier.value

    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_2 = read('Test_4_RecordContractRequest.json')
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def docusignEnvelopeID = response.docusignEnvelopeID
    * def Account_Number = request_2.customerIdentifier.value
    * def contractID = response.recordedContractSummary[0].contractID
    And match response.docusignURL[0].url == "#present"
    And match response.docusignURL[0].termID contains "XH_EQUIP"

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_3 = read('Test_6_getContractRequest.json')
    And request request_3
    * set request_3.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains "PRESENTED"

    * karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgres')

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_4 = read('Test_7_queryContractRequest.json')
    And request request_4
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains 'XH'
    And match $response[*].customerIdentifier.value contains Account_Number

    Given url Endpoint_REST
    Given path '/completeDocusignContract'
    * def request_5 = read('Test_8_completeDocusignContractRequest.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/contract/document/'
    And param contractGuid = contractID
    And header Authorization = Authorization
    When method GET
    Then status 200
    Then match header Content-Type == 'application/pdf'

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_7 = read('Test_11_getContract_2Request.json')
    And request request_7
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains "ACCEPTED"
