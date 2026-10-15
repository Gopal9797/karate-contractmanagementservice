Feature: ScenarioGet_QueryContract_POS_Expired

  Background:

    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}


  @SubmitContract @1509Get_QueryContract_POS_Expired
  Scenario Outline: Get_QueryContract_POS_Expired
    * def AccountNumber = '<Acc_Presented1>'



    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given url Endpoint_REST
    Given path '/submitContract'
    * def request_2 = read('Test_3_SOAP_SubmitContract_ExpiredRequest.json')
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_3 = read('Test_5_SOAP_QueryContract.json')
    And request request_3
    * karate.pause(40000)
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response[0].contractID
    And match $response[*].status contains 'EXPIRED'

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_4 = read('Test_6_SOAP_getContract_StatusCheckRequest.json')
    And request request_4
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains 'EXPIRED'

    Examples:
      | Acc_Presented1   | Acc_Acknowledged1 | Acc_Accepted1    | TrackingCode | TermID        | TermType  | MarketId | TermLen | OrderId1 | OrderId2 | Outlet1 | CSG_AcceptanceCode |
      | 8919100012838455 | 8919100012838455  | 8919100012838455 | HT468        | $230ETF_2YEAR | COMMIT_VA | 9826    | 24      | 1        | 2        | 1       | OT695              |
   
 