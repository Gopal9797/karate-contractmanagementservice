Feature: SMS Marketing - PHONE_NUMBER

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}


  @P2K @SMS_Marketing @PhoneNumber
  Scenario Outline: SMS Marketing with <PhoneNumber> for <TermID>
    * def PhoneNumberDef = global_extension.phoneNumber
    * print PhoneNumberDef
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
    And match $response[*].termID contains "<TermID>"
    And match $response[*].customerIdentifier.value contains PhoneNumberDef
    And match $response[*].status contains "ACCEPTED"

    Given url Endpoint_REST
    Given path '/modifyContractStatusModification'
    * def request_5 = read('ModifyContractStatusModificationRequest.json')
    And request request_5
    * set request_5.contractID = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_6 = read('GetContractRequest.json')
    And request request_6
    * set request_6.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_9 = read('QueryContractRequest.json')
    And request request_9
    * set request_9.contractCriteria.customerIdentifier[0].value = PhoneNumberDef
    * set request_9.contractCriteria.termType[0] = "<TermType>"
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains "<TermType>"
    And match $response[*].termID contains "<TermID>"
    And match $response[*].customerIdentifier.value contains PhoneNumberDef
    And match $response[*].status contains "CANCELLED"
    Examples:
      | PhoneNumber         | TermID       | TermType        |
      | phoneNumber         | TOS_SMS_TEST | TERMS_OF_SERVICE |
      | phoneNumberwithPlus | TOS_SMS_TEST | TERMS_OF_SERVICE |
