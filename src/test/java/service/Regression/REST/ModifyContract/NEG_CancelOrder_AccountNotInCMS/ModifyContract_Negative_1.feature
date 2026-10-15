Feature: ScenarioModifyContract_NEG_CancelOrder_AccountNotInCMS

  Background:

    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}


    * def global_extension = call read('classpath:extension_tool.feature')

  @P2K @ModifyContract
  Scenario: ScenarioModifyContract_NEG_CancelOrder_AccountNotInCMS ScenarioModifyContract_NEG_CancelOrder_AccountNotInCMS
    Given url Endpoint_REST
    Given path '/modifyContractOrderCancellation'
    * def request_0 = read('Test_1_modifyContractRequest.json')
    And request request_0
    And header Authorization = Authorization
    When method POST
    Then assert responseStatus == 400 || responseStatus == 500
    And match response.code == 'CONTRACTMANAGEMENT-1035'
    And match response.message contains 'No contracts found for the account: Account Id -'
   
 