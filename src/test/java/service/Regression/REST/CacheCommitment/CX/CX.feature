Feature: CX - Cache Commitment

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}


  @P2K @CacheCommitment @CacheCX
  Scenario Outline: Validate Cache Commitment of <TermType> term types for <TermID>
    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    * def TermID = "<TermID>"
    * def query = "delete from cms.term_id_reference where term_id = '" + TermID  + "';"
    * call read('classpath:service/Regression/util/CoreTables.feature@term_id_referenceDelete')
    Given url Endpoint_REST
    Given path '/recordContract'
    * def RecordContractRequest = read('RecordContractRequest.json')
    And request RecordContractRequest
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def Account_Number = RecordContractRequest.customerIdentifier.value
    * def orderID = RecordContractRequest.orderID
    * def contractID = response.recordedContractSummary[0].contractID

    Given url Endpoint_REST
    Given path '/getContract'
    * def GetContractRequest = read('GetContractRequest.json')
    And request GetContractRequest
    * set GetContractRequest.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def assertContractStatus = global_extension.assertionStatus(response)
    * match assertContractStatus == true
    * karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgres')

    * def query = "select * from cms.term_id_reference where term_id in('" + TermID + "');"
    * def queryResult = call read('classpath:service/Regression/util/CoreTables.feature@term_id_reference')
    * print queryResult.term_id_reference
#    * match queryResult.term_id_reference[*].term_id contains "<TermID>"
#    * match queryResult.term_id_reference[*].created_by contains "RecordContractCall"
    Examples:
      | AccountNumber    | OrderId          | TermID                            | TrackingID |
      | 8919100012518743 | 1160005783791018 | DP_VI_STBLST_50_$79.99x12_2Y_Q314 | CT339      |
      | 8210100200239991 | 1160005783791018 | XH_EIP_2Y_Q119_COMP               | ST276      |
