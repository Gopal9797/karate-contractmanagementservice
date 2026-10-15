Feature: XHContracts_CMTMigration

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}
    * def restClient = call read('classpath:service/Regression/RestClient.feature@restclient')

  @CMT_Migration @XHContracts_CMTMigration
  Scenario Outline: <termType> for <TermID>


    #   * if (envCheck.ContractCMTReadFlag == "CMT") karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_2 = read('Test_4_RecordContractRequest.json')
    And request request_2
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200
    * def docusignEnvelopeID = response.docusignEnvelopeID
    * def Account_Number = request_2.customerIdentifier.value
    * def contractID = response.recordedContractSummary[0].contractID
    * def CMTChangesContractID = contractID
    And match response.docusignURL[0].url == "#present"
    And match response.docusignURL[0].termID contains "<TermID>"

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_3 = read('Test_6_getContractRequest.json')
    And request request_3
    * set request_3.contractID[0] = contractID
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200
    * def assertContractStatus = global_extension.assertionStatus(response)
    * match assertContractStatus == true
    * call read('classpath:service/Regression/util/Database.feature@selectContract')

    *  if (envCheck.ContractCMTReadFlag == "CMT") karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgres')

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_4 = read('Test_7_queryContractRequest.json')
    And request request_4
    * set request_4.contractCriteria.customerIdentifier[0].value = '<AccountNumber>'
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains 'XH'
    And match $response[*].customerIdentifier.value contains "<AccountNumber>"
    And match ['ACCEPTED','PRESENTED'] contains any $response[*].status
    * call read('classpath:service/CMTMigration/sample.feature@CMTCodeCassandra')

    Given url Endpoint_REST
    Given path '/completeDocusignContract'
    * def request_5 = read('Test_8_completeDocusignContractRequest.json')
    And request request_5
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/contract/document/'
    And param contractGuid = contractID
    And header Authorization = restClient.Authorization
    When method GET
    Then status 200
    Then match header Content-Type == 'application/pdf'

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_7 = read('Test_11_getContract_2Request.json')
    And request request_7
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200
    * def assertContractStatus = global_extension.assertionStatus(response)
    * match assertContractStatus == true
    * call read('classpath:service/Regression/util/Database.feature@selectContract_Accepted')
    *  if (envCheck.ContractCMTReadFlag == "CMT") karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgresAccepted')

    * call read('classpath:service/Regression/util/Database.feature@deleteContractFromDB')
    Given url Endpoint_REST_ProdCode
    Given path '/recordContract'
    * def request_2 = read('Test_4_RecordContractRequest.json')
    And request request_2
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200
    * def docusignEnvelopeID = response.docusignEnvelopeID
    * def Account_Number = request_2.customerIdentifier.value
    * def contractID = response.recordedContractSummary[0].contractID
    * def ProdCodeContractID = contractID
    And match response.docusignURL[0].url == "#present"
    And match response.docusignURL[0].termID contains "<TermID>"

    Given url Endpoint_REST_ProdCode
    Given path '/getContract'
    * def request_3 = read('Test_6_getContractRequest.json')
    And request request_3
    * set request_3.contractID[0] = contractID
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200
    * def assertContractStatus = global_extension.assertionStatus(response)
    * match assertContractStatus == true
    * call read('classpath:service/Regression/util/Database.feature@selectContract')

    Given url Endpoint_REST_ProdCode
    Given path '/queryContract'
    * def request_4 = read('Test_7_queryContractRequest.json')
    And request request_4
    * set request_4.contractCriteria.customerIdentifier[0].value = '<AccountNumber>'
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains 'XH'
    And match $response[*].customerIdentifier.value contains "<AccountNumber>"
    And match ['ACCEPTED','PRESENTED'] contains any $response[*].status
    * call read('classpath:service/CMTMigration/sample.feature@ProdCodeCassandra')

    Given url Endpoint_REST_ProdCode
    Given path '/completeDocusignContract'
    * def request_5 = read('Test_8_completeDocusignContractRequest.json')
    And request request_5
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST_ProdCode
    Given path '/contract/document/'
    And param contractGuid = contractID
    And header Authorization = restClient.Authorization
    When method GET
    Then status 200
    Then match header Content-Type == 'application/pdf'

    Given url Endpoint_REST_ProdCode
    Given path '/getContract'
    * def request_7 = read('Test_11_getContract_2Request.json')
    And request request_7
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200
    * def assertContractStatus = global_extension.assertionStatus(response)
    * match assertContractStatus == true
    * call read('classpath:service/Regression/util/Database.feature@selectContract_Accepted')

    Examples:
      | AccountNumber    | OrderId          | TermID    | termType |
      | 8919100012537727 | 1160005567251015 | XH_EQUIP  | XH       |
#      | 8919100012533841 | 123              | XH_SUB    | XH       |
#      | 8919100012536117 | 978788           | XH_MANUAL | XH       |