Feature: SMS Marketing - EMAIL_ADDRESS

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}


  @P2K @SMS_Marketing @EmailAddressWithoutSomeParameters
  Scenario Outline: SMS Marketing with <EmailAddress> for <TermID>
    * def EmailAddressDef = global_extension.<EmailAddress>
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgresEmailAddress')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_2 = read('RecordContractRequest.json')
    * set request_2.customerIdentifier.value = EmailAddressDef
    * remove request_2.<Parameter>
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
    * karate.call('classpath:service/Regression/util/PGDatabase.feature@selectPartyFromPartyTableEmailAddress')

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_4 = read('QueryContractRequest.json')
    And request request_4
    * set request_4.contractCriteria.customerIdentifier[0].value = EmailAddressDef
    * set request_4.contractCriteria.termType[0] = 'TERMS_OF_SERVICE'
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains "TERMS_OF_SERVICE"
    And match $response[*].termID contains "<TermID>"
    And match $response[*].customerIdentifier.value contains EmailAddressDef
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
    * set request_9.contractCriteria.customerIdentifier[0].value = EmailAddressDef
    * set request_9.contractCriteria.termType[0] = "<TermType>"
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains "<TermType>"
    And match $response[*].termID contains "<TermID>"
    And match $response[*].customerIdentifier.value contains EmailAddressDef
    And match $response[*].status contains "CANCELLED"

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_9 = read('QueryContractTermIDRequest.json')
    And request request_9
    * set request_9.contractCriteria.customerIdentifier[0].value = EmailAddressDef
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains "<TermType>"
    And match $response[*].termID contains "<TermID>"
    And match $response[*].customerIdentifier.value contains EmailAddressDef
    And match $response[*].status contains "CANCELLED"
    Examples:
      | EmailAddress | TermID         | TermType         | Parameter                                  |
      | EmailAddress | TOS_EMAIL_TEST | TERMS_OF_SERVICE | sourceChannel                              |
      | EmailAddress | TOS_EMAIL_TEST | TERMS_OF_SERVICE | orderID                                    |
      | EmailAddress | TOS_EMAIL_TEST | TERMS_OF_SERVICE | contractSpecification[0].contractParameter |
      | EmailAddress | TOS_EMAIL_TEST | TERMS_OF_SERVICE | contractSpecification[0].signer            |
      | EmailAddress | TOS_EMAIL_TEST | TERMS_OF_SERVICE | contractSpecification[0].contractStartDate |
