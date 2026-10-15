Feature: ScenarioGet_QueryContract_POS_ACCEPTED

  Background:

    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}


  @P2K @QueryContract @Get_QueryContract_POS_ACCEPTED
  Scenario Outline: Get_QueryContract_POS_ACCEPTED
    * def AccountNumber = <Acc_Presented1>



    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_2 = read('Test_3_SOAP_recordContractRequest.json')
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID

    Given url Endpoint_REST
    Given path '/modifyContractStatusModification'
    * def request_3 = read('Test_4_modifyContract_PRESENTED_to_ACCEPTEDRequest.json')
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_4 = read('Test_6_SOAP_QueryContract_StatusCheck_getContractGUIDRequest.json')
    And request request_4
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_5 = read('Test_7_SOAP_getContract_StatusCheckRequest.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then status 200

    Examples:
      | Acc_Presented1   | Acc_Acknowledged1 | Acc_Accepted1    | TrackingCode | TermID                            | TermType  | MarketId | TermLen | OrderId1 | OrderId2 | Outlet1 | CSG_AcceptanceCode |
      | 8919100011339372 | 8919100011339372  | 8919100011339372 | CT339        | DP_VI_STBLST_50_$79.99x12_2Y_Q314 | COMMIT_VA | 9826    | 24      | 1        | 2        | 1       | OT695              |
   
 