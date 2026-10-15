Feature: SubmitContract_CSG_COMMIT_WO_VA

  Background:

    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.currentTime)'}


  @SubmitContract @SubmitContract_CSG_COMMIT_WO_VA
  Scenario Outline: SubmitContract_CSG_COMMIT_WO_VA
    * def AccountNumber = <Acc>
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given url Endpoint_REST
    Given path '/submitContract'
    * def request_2 = read('Test_3_SOAPRequest.json')
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * karate.pause(40000)

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_3 = read('Test_5_SOAP_QueryContractRequest.json')
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response[0].termID contains '<TermID>'
    And match $response[*].status contains 'PRESENTED'
    And match response[0].language contains 'ENGLISH'
    And match response[0].customerIdentifier.value contains '<Acc>'
    And match response[0].termType contains '<TermType>'
    And match $response[*].termName contains '<TermName>'
    And match response[0].legacyContractIndicator  == false
    * def contractID = response[0].contractID

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_4 = read('Test_6_SOAP_getContractRequest.json')
    And request request_4
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains contractID
    And match response contains '<TermID>'
    And match response contains 'PRESENTED'
#    And match (response) contains any  {"ACCEPTED","PRESENTED"}
    And match response contains '<Acc>'
    And match response contains 'CMS'
    And match response contains 'WEB'
    And match response contains '<TermType>'
    And match response contains '<TermName>'
    And match response contains '<OrderId>'
    And match response contains 'false'
#    And match response contains '<CSG_TrackingCode>'

    Examples:
      | Acc              | CSG_TrackingCode | TermID                              | TermType     | MarketId | TermName                                        | TermLen | OrderId | Outlet |
      | 8210100200228895 | CT3395           | NON_DS_TEST_COMMIT_WO_VA_DO_NOT_USE | COMMIT_WO_VA | 9826    | SP_V_PF_DCOM_Q412_VIDEO_DO_NOT_USE COMMIT_WO_VA | 24      | 1       | 1      |
   
 