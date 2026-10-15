Feature: TestSuiteUS434123_CMS_QueryContract_NEG_AccNotInDB

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}


  @QueryContract  @QueryContract_0011  @P2K
  Scenario: TestSuiteUS434123_CMS_QueryContract_NEG_AccNotInDB TestSuiteUS434123_CMS_QueryContract_NEG_AccNotInDB
    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_0 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_0
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response == []

