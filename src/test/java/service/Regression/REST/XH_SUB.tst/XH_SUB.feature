Feature: XH_SUB.tst

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}

    * def request_2 = read('Test_2_RecordContractRequest.json')

  @P2K @XH_SUB
  Scenario: XH_SUB
    * def TermID = "XH_SUB"
    * def AccountNumber = request_2.customerIdentifier.value

    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def request_0 = read('Test_2_RecordContractRequest.json')
    And request request_0
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID
    * def Account_Number = request_0.customerIdentifier.value
    * def orderID = request_0.orderID

    Given url Endpoint_REST
    Given path '/getContract'
    * def request_1 = read('Test_4_getContractRequest.json')
    And request request_1
    * set request_1.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200

    * karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgres')

    Given url Endpoint_REST
    Given path '/queryContract'
    * def request_2 = read('Test_5_queryContractRequest.json')
    And request request_2
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termType contains 'XH'
    And match $response[*].customerIdentifier.value contains '8210100200228697'

    * karate.pause(10000)
    * def query = "Select * from cms.cms_technician_detail where technician_name = '" + global_extension.Technician_Name  + "';"
    * def queryResult = call read('classpath:service/Regression/util/CoreTables.feature@cms_technician_detail')
    * print queryResult.cms_technician_detail
    * match queryResult.cms_technician_detail[*].technician_name contains global_extension.Technician_Name
    * match queryResult.cms_technician_detail[*].technician_id contains global_extension.Technician_Id
    * match queryResult.cms_technician_detail[*].email_address contains global_extension.Tech_Email