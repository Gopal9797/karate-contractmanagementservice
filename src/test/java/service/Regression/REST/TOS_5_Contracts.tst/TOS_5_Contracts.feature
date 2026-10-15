Feature: TOS_5_Contracts

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}

    * def request_2 = read('Test_4_RecordContractRequest.json')

  @P2K @TOS5
  Scenario: TOS_5_Contracts
    * def AccountNumber = request_2.customerIdentifier.value
    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteAllContractsWithAccNumber')
    Given url Endpoint_REST
    Given path '/recordContract'
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def Account_Number = request_2.customerIdentifier.value
    * def contractID_1 = response.recordedContractSummary[0].contractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    * def contractID_2 = response.recordedContractSummary[1].contractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    * def contractID_3 = response.recordedContractSummary[2].contractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    * def contractID_4 = response.recordedContractSummary[3].contractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")
    * def contractID_5 = response.recordedContractSummary[4].contractID.replace(/(\w{8})(\w{4})(\w{4})(\w{4})(\w{4})/, "$1-$2-$3-$4-$5")

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_3 = read('Test_6_getContractRequest.json')
    And request request_3
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains "ACCEPTED"

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_4 = read('Test_7_queryContractRequest.json')
    * set request_4.contractCriteria.customerIdentifier[0].value = Account_Number
    * set request_4.contractCriteria.termType[0] = 'TERMS_OF_SERVICE'
    And header Authorization = Authorization
    And request request_4
    When method POST
    Then status 200
    And match $response[*].termType contains "TERMS_OF_SERVICE"
    And match $response[*].customerIdentifier.value contains Account_Number
    And match $response[*].status contains "ACCEPTED"
    * def TOSContracts = $response[*].contractID
    And print 'Total Number of TOS Contracts: ', TOSContracts.length
#    And match TOSContracts.length == 20
#    * def contractGUID = contractID_1 + "," + contractID_2 + "," + contractID_3 + "," + contractID_4 + "," + contractID_5
#    * print contractGUID

#    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteMultipleContracts')
#    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteMultipleContracts')