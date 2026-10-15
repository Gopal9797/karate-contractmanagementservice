Feature: SMS Marketing - PHONE_NUMBER

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}


  @P2K @SMS_Marketing @PhoneNumber
  Scenario Outline: SMS Marketing with <PhoneNumber> for <TermID>
    * def PhoneNumberDef = global_extension.<PhoneNumber>
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgresPhoneNumber')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_2 = read('RecordContractRequest.json')
    * set request_2.customerIdentifier.value = PhoneNumberDef
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID

    Given url Endpoint_REST
    Given path '/modifyContractStatusModification'
    * def request_5 = read('ModifyContractStatusModificationRequest.json')
    And request request_5
    * set request_5.contractID = contractID
    * set request_5.status = "ACCEPTED"
    And header Authorization = Authorization
    When method POST
    Then status 500
    And match response.message contains "Contract Status update is not allowed for Contract Id:"
    And match response.message contains "From ACCEPTED to ACCEPTED"
    And match response.code contains "CONTRACTMANAGEMENT-1034"

    Given url Endpoint_REST
    Given path '/modifyContractStatusModification'
    * def request_5 = read('ModifyContractStatusModificationRequest.json')
    And request request_5
    * set request_5.contractID = contractID
    * set request_5.status = "CANCELLED"
    * remove request_5.contractEndDate
    And header Authorization = Authorization
    When method POST
    Then status 500
    And match response.message contains "End Date is required for modify contract with unknown term type to terminated/Cancelled status."
    And match response.code contains "CONTRACTMANAGEMENT-1064"

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_3 = read('GetContractRequest.json')
    And request request_3
    * set request_3.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains "ACCEPTED"

    * karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgresAccepted')
    * karate.call('classpath:service/Regression/util/PGDatabase.feature@selectPartyFromPartyTablePhoneNumber')

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_4 = read('QueryContractRequest.json')
    And request request_4
    * set request_4.contractCriteria.customerIdentifier[0].value = PhoneNumberDef
    * set request_4.contractCriteria.termType[0] = 'TERMS_OF_SERVICE'
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains "TERMS_OF_SERVICE"
    And match $response[*].customerIdentifier.value contains PhoneNumberDef
    And match $response[*].status contains "ACCEPTED"

    Given url Endpoint_REST
    Given path '/modifyContractStatusModification'
    * def request_5 = read('ModifyContractStatusModificationRequest.json')
    And request request_5
    * remove request_5.acceptanceMethod
    * set request_5.contractID = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_9 = read('QueryContractRequest.json')
    And request request_9
    * set request_9.contractCriteria.customerIdentifier[0].value = PhoneNumberDef
    * set request_9.contractCriteria.termType[0] = "ALL"
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains "<TermType>"
    And match $response[*].customerIdentifier.value contains PhoneNumberDef
    And match $response[*].status contains "CANCELLED"

    Given url Endpoint_REST
    Given path '/modifyContractStatusModification'
    * def request_5 = read('ModifyContractStatusModificationRequest.json')
    And request request_5
    * set request_5.contractID = contractID
    * set request_5.status = "CANCELLED"
    And header Authorization = Authorization
    When method POST
    Then status 500
    And match response.message contains "Contract Status update is not allowed for Contract Id:"
    And match response.message contains "From CANCELLED to CANCELLED"
    And match response.code contains "CONTRACTMANAGEMENT-1034"

    Given url Endpoint_REST
    Given path '/modifyContractStatusModification'
    * def request_5 = read('ModifyContractStatusModificationRequest.json')
    And request request_5
    * set request_5.contractID = contractID
    * set request_5.status = "ACCEPTED"
    And header Authorization = Authorization
    When method POST
    Then status 500
    And match response.message contains "Contract Status update is not allowed for Contract Id:"
    And match response.message contains "From CANCELLED to ACCEPTED"
    And match response.code contains "CONTRACTMANAGEMENT-1034"
    Examples:
      | PhoneNumber | TermID       | TermType        |
      | phoneNumber | TOS_SMS_TEST | TERMS_OF_SERVICE |
