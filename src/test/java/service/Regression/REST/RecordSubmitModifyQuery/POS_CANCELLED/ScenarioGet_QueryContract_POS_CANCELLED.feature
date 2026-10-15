Feature: ScenarioGet_QueryContract_POS_CANCELLED

  Background:

    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}


  @SubmitContract @QueryContract @Get_QueryContract_POS_CANCELLED
  Scenario Outline: Get_QueryContract_POS_CANCELLED
    * def AccountNumber = <Acc_Presented1>
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_2 = read('Test_2_SOAP_recordContractRequest.json')
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID

    Given url Endpoint_REST
    Given path '/submitContract'
    * def request_3 = read('Test_3_SOAP_CancelOrderRequest.json')
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200

    * karate.pause(40000)
    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_4 = read('Test_5_SOAP_QueryContract_StatusCheck_getContractGUIDRequest.json')
    And request request_4
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].status contains 'CANCELLED'

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_5 = read('Test_6_SOAP_getContract_StatusCheckRequest.json')
    And request request_5
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains 'CANCELLED'
    Examples:
      | Acc_Presented1   | Acc_Acknowledged1 | Acc_Accepted1    | TrackingCode | TermID                            | MarketId | TermLen | OrderId1 | OrderId2 | Outlet1 | CSG_AcceptanceCode | contractID                       | Test3contractID                  |
      | 8919100011339372 | 8155500070236018  | 8155600388125315 | CT339        | DP_VI_STBLST_50_$79.99x12_2Y_Q314 | 9826       | 1       | 2        | 1        | OT695   | WEB                | de2713f16b8811ecbd4951908aac184c | 412968106b6e11ec816ed78dee0c0c8e |
   
 