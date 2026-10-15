Feature: ScenarioGet_QueryContract_POS_TERMINATED

  Background:

    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}


  @SubmitContract @QueryContract @Get_QueryContract_POS_TERMINATED
  Scenario Outline: ScenarioGet_QueryContract_POS_TERMINATED ScenarioGet_QueryContract_POS_TERMINATED
    * def AccountNumber = <Acc_Acknowledged1>
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
    Given path '/queryContract'
    * def request_3 = read('Test_4_SOAP_QueryContract_StatusListCheck_2Request.json')
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/submitContract'
    * def request_4 = read('Test_5_SOAP_TerminateAccountRequest.json')
    And request request_4
    And header Authorization = Authorization
    When method POST
    Then status 200
    * karate.pause(40000)

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_5 = read('Test_7_SOAP_QueryContract_StatusCheck_PresentOrderId_getContractGUIDRequest.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_6 = read('Test_8_SOAP_QueryContract_StatusCheck_TerminateOrderId_getContractGUIDRequest.json')
    And request request_6
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_7 = read('Test_9_SOAP_getContract_StatusCheckRequest.json')
    And request request_7
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains 'TERMINATED'

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_8 = read('Test_10_SOAP_QueryContract_StatusCheck_TerminateOrderId_getContractGUID_2Request.json')
    And request request_8
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_9 = read('Test_11_SOAP_QueryContract_StatusListCheckRequest.json')
    And request request_9
    And header Authorization = Authorization
    When method POST
    Then status 200

    Examples:
      | Acc_Presented1   | Acc_Acknowledged1 | Acc_Accepted1    | TrackingCode | TermID                            | MarketId | TermLen | OrderId1 | OrderId2 | Outlet1 | CSG_AcceptanceCode | contractID                       | Test3contractID                  |
      | 8155400392926422 | 8919100011796381  | 8155600388125315 | CT339        | DP_VI_STBLST_50_$79.99x12_2Y_Q314 | 9826     | 1       | 1        | 1        | OT695   | WEB                | 036b4b929d8826c4e05360aefc0a13b4 | 412968106b6e11ec816ed78dee0c0c8e |
   
 