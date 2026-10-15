Feature: ScenarioTestSuite

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}


  @P2K @QueryContract @1507QCScenarioTestSuite
  Scenario Outline: ScenarioTestSuite ScenarioTestSuite
    * def AccountNumber = '<Acc1>'



    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_6 = read('Test_7_SOAP_recordContract_AccRequest.json')
    And request request_6
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def Test2contractID = response.recordedContractSummary[0].contractID

    Given url Endpoint_REST
    Given path '/submitContract'
    * def request_7 = read('Test_8_SOAP_TerminateAccountRequest.json')
    And request request_7
    And header Authorization = Authorization
    When method POST
    Then status 200

    * def AccountNumber = '<Acc2>'



    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_8 = read('Test_10_SOAP_recordContract_Acc_2Request.json')
    And request request_8
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def Test2contractID2 = response.recordedContractSummary[0].contractID

    Given url Endpoint_REST
    Given path '/submitContract'
    * def request_9 = read('Test_11_SOAP_CancelOrder_2Request.json')
    And request request_9
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_10 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_10
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match ['ACCEPTED','PRESENTED'] contains any $response[0].status
    And match response[0].contractID contains Test2contractID

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_11 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_11
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match ['ACCEPTED','PRESENTED'] contains any $response[0].status
    And match response[0].contractID contains Test2contractID

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_12 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_12
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_13 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_13
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_14 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_14
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match ['ACCEPTED','PRESENTED'] contains any $response[0].status
    And match response[0].contractID contains Test2contractID

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_15 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_15
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_16 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_16
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_17 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_17
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match ['ACCEPTED','PRESENTED'] contains any $response[0].status
    And match response[0].contractID contains Test2contractID

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_18 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_18
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_19 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_19
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match ['ACCEPTED','PRESENTED'] contains any $response[0].status
    And match response[0].contractID contains Test2contractID

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_20 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_20
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match ['ACCEPTED','PRESENTED'] contains any $response[0].status
    And match response[0].contractID contains Test2contractID

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_21 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_21
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_22 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_22
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_23 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_23
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match ['ACCEPTED','PRESENTED'] contains any $response[0].status
    And match response[0].contractID contains Test2contractID

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_24 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_24
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_25 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_25
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_26 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_26
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match ['ACCEPTED','PRESENTED'] contains any $response[0].status
    And match response[0].contractID contains Test2contractID

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_27 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_27
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_28 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_28
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match ['ACCEPTED','PRESENTED'] contains any $response[0].status
    And match response[0].contractID contains Test2contractID

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_29 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_29
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_30 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_30
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/submitContract'
    * def request_31 = read('Test_1_SOAP_CreateContractRequest.json')
    And request request_31
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/submitContract'
    * def request_32 = read('Test_3_SOAP_TerminateRequest.json')
    And request request_32
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_33 = read('Test_5_Soap_QueryContractRequest.json')
    And request request_33
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_34 = read('Test_1_Soap_QueryContractRequest.json')
    And request request_34
    And header Authorization = Authorization
    When method POST
    Then status 200

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_35 = read('Test_2_Soap_QueryContractRequest.json')
    And request request_35
    And header Authorization = Authorization
    When method POST
    Then assert responseStatus == 400 || responseStatus == 500
    And match response.code contains 'COMMON-1010'
    And match response.validationMessages[0] contains 'value can not be null or empty.'
    And match response.validationMessages[1] contains 'Account Number should not be empty or null.'

    Examples:
      | Acc1             | Acc2             | Acc3             | TrackingCode | TrackingCode_Commit_WO_VA | AcceptanceCode | TermID                            | TermType  | MarketId | TermIDNotMatchChk                         | OrderId1 | OrderId2 | Outlet1 | Outlet2 | SignerEmail             |
      | 8919100010834530 | 8045100010242343 | 8045100010242350 | CT339        | AT761                     | OT695          | DP_VI_STBLST_50_$79.99x12_2Y_Q314 | COMMIT_VA | 23879    | TP_VIP_HDPM_200AMZ_$159.99x24_2Y_Q114_HVA | 1        | 2        | 1       | 2       | CMSQA@cable.comcast.com |
 