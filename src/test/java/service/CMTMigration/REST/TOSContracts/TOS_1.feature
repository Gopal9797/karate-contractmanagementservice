Feature: TOSContracts_CMTMigration

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}
    * def restClient = call read('classpath:service/Regression/RestClient.feature@restclient')

  @CMT_Migration @TOSContracts_CMTMigration
  Scenario Outline: TERMS_OF_SERVICE for <TermID>


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
    * call read('classpath:service/Regression/util/Database.feature@selectContract_Accepted')
    *  if (envCheck.ContractCMTReadFlag == "CMT") karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgresAccepted')

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
    * call read('classpath:service/Regression/util/Database.feature@selectContract_Accepted')

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
      | AccountNumber    | OrderId          | TermID                     | termType         |
      | 8919100012890084 | 1160005567251015 | TOS_LEARN_MORE_BTV_RSN     | TERMS_OF_SERVICE |
      | 8210100200228895 | 1160005567251015 | TOS_LEARN_MORE_POST_PROMO  | TERMS_OF_SERVICE |
      | 8210100200239991 | 1160005783791018 | TOS_CHARGES_LEARN_MORE_BTV | TERMS_OF_SERVICE |
      | 8210100200228697 | 1160005563451015 | TOS_TERMS_CONDITIONS_1     | TERMS_OF_SERVICE |
      | 8919100010857622 | 1160005783791018 | TOS_PRICING                | TERMS_OF_SERVICE |
#      | 8919100012540234 | 1160005783791018 | XMOBILE_CONSENT_DS02       | TERMS_OF_SERVICE |

  @CMT_Migration @TOSContracts_CMTMigration @XMobile_CMTMigration
  Scenario Outline: TERMS_OF_SERVICE for <TermID>


    #   * if (envCheck.ContractCMTReadFlag == "CMT") karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_2 = read('XmobileRecordContract.json')
    And request request_2
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200
    * def IdentityValue = request_2.customerIdentifier.value
    * def docusignEnvelopeID = response.docusignEnvelopeID
    And match response.docusignEnvelopeID == "#present"
    And match $response.docusignURL[*].url == "#present"
    * def contractID = response.recordedContractSummary[0].contractID
    * def CMTChangesContractID = contractID

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_3 = read('XmobileGetContract.json')
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
    * def request_4 = read('XmobileQueryContract.json')
    And request request_4
    * set request_4.contractCriteria.customerIdentifier[0].value = IdentityValue
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains 'TERMS_OF_SERVICE'
    And match $response[*].customerIdentifier.value contains IdentityValue
    And match ['ACCEPTED','PRESENTED'] contains any $response[*].status
    And match $response[*].contractID contains contractID
    * call read('classpath:service/CMTMigration/sample.feature@CMTCodeCassandra')

    * call read('classpath:service/Regression/util/Database.feature@deleteContractFromDB')
    Given url Endpoint_REST_ProdCode
    Given path '/recordContract'
    * def request_2 = read('XmobileRecordContract.json')
    And request request_2
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200
    * def IdentityValue = request_2.customerIdentifier.value
    * def docusignEnvelopeID = response.docusignEnvelopeID
    And match response.docusignEnvelopeID == "#present"
    And match $response.docusignURL[*].url == "#present"
    * def contractID = response.recordedContractSummary[0].contractID
    * def ProdCodeContractID = contractID

    Given url Endpoint_REST_ProdCode
    Given path '/getContract'
    * def request_3 = read('XmobileGetContract.json')
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
    * def request_4 = read('XmobileQueryContract.json')
    And request request_4
    * set request_4.contractCriteria.customerIdentifier[0].value = IdentityValue
    And header Authorization = restClient.Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains 'TERMS_OF_SERVICE'
    And match $response[*].customerIdentifier.value contains IdentityValue
    And match ['ACCEPTED','PRESENTED'] contains any $response[*].status
    And match $response[*].contractID contains contractID
    * call read('classpath:service/CMTMigration/sample.feature@ProdCodeCassandra')
#    * if (envCheck.ContractCMTWriteFlag == "CASSANDRA") karate.call('classpath:service/CMTMigration/sample.feature@CassandraComparison' , {ProdCodeContractID: ProdCodeContractID, CMTChangesContractID: CMTChangesContractID })
    * if (envCheck.ContractCMTWriteFlag == "CASSANDRA") karate.call('classpath:service/CMTMigration/sample.feature@CassandraComparison')
    * if (envCheck.ContractCMTWriteFlag == "CMT" || envCheck.ContractCMTWriteFlag == "BOTH") karate.call('classpath:service/CMTMigration/sample.feature@samplePy' , {ProdCodeContractID: ProdCodeContractID, CMTChangesContractID: CMTChangesContractID })
    Examples:
      | AccountNumber    | OrderId          | TermID               | termType         |
      | 8919100012540234 | 1160005783791018 | XMOBILE_CONSENT_DS02 | TERMS_OF_SERVICE |
