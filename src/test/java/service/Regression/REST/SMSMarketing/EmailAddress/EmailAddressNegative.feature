Feature: SMS Marketing - EMAIL_ADDRESS

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}


  @P2K @SMS_Marketing @EmailAddressNegativeCases
  Scenario: SMS Marketing with Invalid EmailAddress - Negative
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_2 = read('RecordContractRequest.json')
    * set request_2.customerIdentifier.value = "9284248"
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 400
    And match response.message contains "Invalid Email Address "
    And match response.code contains "CONTRACTMANAGEMENT-1093"
    And match response.validationMessages[0] contains "Invalid Email Address "

  @P2K @SMS_Marketing @EmailAddressNegativeCases
  Scenario: SMS Marketing with Invalid TermID - Negative
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_2 = read('RecordContractRequest.json')
    * set request_2.contractSpecification[0].termID = "INVALIDTermID"
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 500
    And match response.message contains "Account Number is required"
    And match response.code contains "CONTRACTMANAGEMENT-1072"
    And match response.validationMessages contains []