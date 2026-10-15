Feature: Spanish_Support

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}
    * url Endpoint_REST

  @P2K @Spanish_Support @SPANISH
  Scenario Outline: Spanish Support
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given path '/recordContract'
    * def request_2 = read('RecordContractRequest.json')
    * set request_2.contractSpecification[0].termQualifiers.language = 'SPANISH'
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def Account_Number = request_2.customerIdentifier.value
    * def orderID = request_2.orderID
    * def contractID = response.recordedContractSummary[0].contractID

    Given path '/recordContract'
    * def request_2 = read('RecordContractRequest.json')
    * set request_2.contractSpecification[0].termQualifiers.language = 'ENGLISH'
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 500
    And match response.message contains "Duplicate contract found in database for Account Number"
    And match response.code contains "CONTRACTMANAGEMENT-1029"

    Given path '/getContract'
    * def request_3 = read('getContractRequest.json')
    And request request_3
    * set request_3.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
#    And match response contains "PRESENTED"
    * def assertContractStatus = global_extension.assertionStatus(response)
    * match assertContractStatus == true

    * def dbCall = karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgres')
    * match dbCall.ContractInformation[*].language_ind contains "SPANISH"

    Given path '/queryContract'
    * def request_4 = read('queryContractRequest.json')
    And request request_4
    * set request_4.contractCriteria.customerIdentifier[0].value = '<AccountNumber>'
    * set request_4.contractCriteria.termType[0] = 'COMMIT_VA'
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains "COMMIT_VA"
    And match $response[*].language contains "SPANISH"
    And match $response[*].customerIdentifier.value contains "<AccountNumber>"
    And match $response[*].status contains "PRESENTED"

    Given path '/modifyContractStatusModification'
    * def request_5 = read('modifyContractStatusModificationRequest.json')
    And request request_5
    * set request_5.contractID = contractID
    * set request_5.orderID = '<OrderId>'
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given path '/getContract'
    * def request_6 = read('getContractRequest.json')
    And request request_6
    * set request_6.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given path '/queryContract'
    * def request_9 = read('queryContractRequest.json')
    And request request_9
    * set request_9.contractCriteria.customerIdentifier[0].value = '<AccountNumber>'
    * set request_9.contractCriteria.termType[0] = 'COMMIT_VA'
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains "COMMIT_VA"
    And match $response[*].language contains "SPANISH"
    And match $response[*].customerIdentifier.value contains "<AccountNumber>"
    And match $response[*].status contains "ACKNOWLEDGED"

    Given path '/modifyContractOrderCancellation'
    * def request_7 = read('modifyContractOrderCancellationRequest.json')
    And request request_7
    * set request_7.accountNumber = '<AccountNumber>'
    * set request_7.orderID = '<OrderId>'
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given path '/getContract'
    * def request_8 = read('getContractRequest.json')
    And request request_8
    * set request_8.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains "CANCELLED"

    Given path '/queryContract'
    * def request_9 = read('queryContractRequest.json')
    And request request_9
    * set request_9.contractCriteria.customerIdentifier[0].value = '<AccountNumber>'
    * set request_9.contractCriteria.termType[0] = 'COMMIT_VA'
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains "COMMIT_VA"
    And match $response[*].language contains "SPANISH"
    And match $response[*].customerIdentifier.value contains "<AccountNumber>"
    And match $response[*].status contains "CANCELLED"

    Examples:
      | AccountNumber    | OrderId          | TermID                            | TrackingID |
      | 8919100012537727 | 1160005567251015 | $110ETF_1YEAR_SelfServ            | OT1BE      |
      | 8919100012537727 | 1160005783791018 | DP_VI_STBLST_50_$79.99x12_2Y_Q314 | CT339      |
