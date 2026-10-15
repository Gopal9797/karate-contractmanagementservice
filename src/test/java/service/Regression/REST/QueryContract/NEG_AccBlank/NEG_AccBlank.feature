Feature: TestSuiteUS434123_CMS_QueryContract_NEG_AccBlank

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}


  @QueryContract  @QueryContract_006   @P2K
  Scenario: TestSuiteUS434123_CMS_QueryContract_NEG_AccBlank TestSuiteUS434123_CMS_QueryContract_NEG_AccBlank
    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_0 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_0
    And header Authorization = Authorization
    When method POST
    Then assert responseStatus == 400 || responseStatus == 500
    And match response.code contains 'COMMON-1010'
    And match response.validationMessages contains 'value can not be null or empty.'
    And match response.validationMessages[0] contains 'value can not be null or empty.'
    And match response.validationMessages[1] contains 'Account Number should not be empty or null.'
