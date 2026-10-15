Feature: CXContracts_CMTMigration

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}
    * def restClient = call read('classpath:service/Regression/RestClient.feature@restclient')

  @CMT_Migration @CXContracts_CMTMigration
  Scenario Outline: <termType> for <TermID>


    #   * if (envCheck.ContractCMTReadFlag == "CMT") karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_2 = read('Test_4_RecordContractRequest.json')
    And request request_2
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID
    * def CMTChangesContractID = contractID

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_3 = read('Test_6_getContractRequest.json')
    And request request_3
    * set request_3.contractID[0] = contractID
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200
    * def assertContractStatus = global_extension.assertionStatus(response)
    * match assertContractStatus == true
    * call read('classpath:service/Regression/util/Database.feature@selectContract')

    *  if (envCheck.ContractCMTReadFlag == "CMT") karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgres')

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_4 = read('Test_7_queryContractRequest.json')
    And request request_4
    * set request_4.contractCriteria.customerIdentifier[0].value = '<AccountNumber>'
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains "<termType>"
    And match $response[*].customerIdentifier.value contains "<AccountNumber>"
    And match ['ACCEPTED','PRESENTED'] contains any $response[*].status
    * call read('classpath:service/CMTMigration/sample.feature@CMTCodeCassandra')

    * call read('classpath:service/Regression/util/Database.feature@deleteContractFromDB')
    Given url Endpoint_REST_ProdCode
    Given path '/recordContract'
    * def request_2 = read('Test_4_RecordContractRequest.json')
    And request request_2
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID
    * def ProdCodeContractID = contractID

    Given url Endpoint_REST_ProdCode
    Given path '/getContract'
    * def request_3 = read('Test_6_getContractRequest.json')
    And request request_3
    * set request_3.contractID[0] = contractID
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200
    * def assertContractStatus = global_extension.assertionStatus(response)
    * match assertContractStatus == true
    * call read('classpath:service/Regression/util/Database.feature@selectContract')

    Given url Endpoint_REST_ProdCode
    Given path '/queryContract'
    * def request_4 = read('Test_7_queryContractRequest.json')
    And request request_4
    * set request_4.contractCriteria.customerIdentifier[0].value = '<AccountNumber>'
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains "<termType>"
    And match $response[*].customerIdentifier.value contains "<AccountNumber>"
    And match ['ACCEPTED','PRESENTED'] contains any $response[*].status
    * call read('classpath:service/CMTMigration/sample.feature@ProdCodeCassandra')

#    * if (envCheck.ContractCMTWriteFlag == "CASSANDRA") karate.call('classpath:service/CMTMigration/sample.feature@CassandraComparison' , {ProdCodeContractID: ProdCodeContractID, CMTChangesContractID: CMTChangesContractID })
    * if (envCheck.ContractCMTWriteFlag == "CASSANDRA") karate.call('classpath:service/CMTMigration/sample.feature@CassandraComparison')
    * if (envCheck.ContractCMTWriteFlag == "CMT" || envCheck.ContractCMTWriteFlag == "BOTH") karate.call('classpath:service/CMTMigration/sample.feature@samplePy' , {ProdCodeContractID: ProdCodeContractID, CMTChangesContractID: CMTChangesContractID })
    Examples:
      | AccountNumber    | OrderId          | TermID                                                  | TrackingID | termType      |
      | 8919100012890084 | 1160005567251015 | TP_VIP_X1Premier_200_$159.99x24_2Y_Q416_230ETF_SelfServ | BA         | COMMIT_VA     |
      | 8210100200228895 | 1160005567251015 | NON_DS_TEST_COMMIT_WO_VA_DO_NOT_USE                     | CT3395     | COMMIT_WO_VA  |
      | 8210100200239991 | 1160005783791018 | XH_EIP_2Y_Q119_COMP                                     | ST276      | COMMIT_WO_VA  |
      | 8210100200228697 | 1160005563451015 | CNT_for_OffrNum_201091                                  | TF026      | NON_COMMIT_VA |
      | 8919100010857622 | 1160005783791018 | SP_INTERNET_25_VA                                       | OT945      | NON_COMMIT_VA |