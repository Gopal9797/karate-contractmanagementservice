Feature: AMS - SOAP2REST

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}
    * url Endpoint_REST
    * def RecordContractRequest = read('RecordContractRequest.json')
    * def TOSRecordContractRequest = read('TOSRecordContractRequest.json')
    * def GetContractRequest = read('GetContractRequest.json')
    * def QueryContractRequest = read('QueryContractRequest.json')
    * def GetBillArrangementRequest = read('GetBillArrangementRequest.json')
    * def AMSAuth = karate.call('classpath:service/Regression/RestClient.feature@OAUTH2AMS')

  @P2K @AMS_SOAP2REST
  Scenario Outline: AMS_SOAP2REST - Null ContractParameters for <TermID>
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteRowsPostgres')
    Given path '/recordContract'
    And request RecordContractRequest
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def Account_Number = RecordContractRequest.customerIdentifier.value
    * def orderID = RecordContractRequest.orderID
    * def contractID = response.recordedContractSummary[0].contractID

    Given path '/getContract'
    And request GetContractRequest
    * set GetContractRequest.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains "PRESENTED"
    And match response contains "<OrderId>"

    Given path '/queryContract'
    And request QueryContractRequest
    * set QueryContractRequest.contractCriteria.customerIdentifier[0].value = '<AccountNumber>'
    * set QueryContractRequest.contractCriteria.termID[0] = '<TermID>'
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termID contains '<TermID>'
    And match $response[*].customerIdentifier.value contains "<AccountNumber>"
    And match $response[*].status contains "PRESENTED"

    * def dbCall = karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgres')
    * string CONTRACT_ATTRIBUTES = dbCall.ContractInformation[0].contract_attributes
    * print CONTRACT_ATTRIBUTES

    Given url 'https://account-api-gateway-int.as-g8.cf.comcast.net/api/account/v1/accountmanagement/billarrangement'
    And request GetBillArrangementRequest
    And header Authorization = AMSAuth.AMSAuthorization
    When method POST
    Then status 200
    And match response[0].billingArrangementID == "<AccountNumber>"
    And match $CONTRACT_ATTRIBUTES[*].value contains response[0].billingPersonName.firstName
    And match $CONTRACT_ATTRIBUTES[*].value contains response[0].billingPersonName.lastName
    And match $CONTRACT_ATTRIBUTES[*].value contains response[0].billingContact.address.streetAddress
    And match $CONTRACT_ATTRIBUTES[*].value contains response[0].billingContact.address.state
    And match $CONTRACT_ATTRIBUTES[*].value contains response[0].billingContact.address.city
    And match $CONTRACT_ATTRIBUTES[*].value contains response[0].billingContact.address.zipCode
#Match all the fields whichever picked from AMS and stored in ContractATtributes field.
    Examples:
      | AccountNumber    | OrderId | TermID                                                  | TrackingID |
      | 8919100010553882 | 13579   | TP_VIP_X1Premier_200_$159.99x24_2Y_Q416_230ETF_SelfServ | BA         |
      | 8919100010553882 | 24680   | XH_EIP_2Y_Q119_COMP                                     | ST276      |
      | 8919100010553882 | 36912   | SP_INTERNET_25_VA                                       | OT945      |

  @P2K @AMS_SOAP2REST @Fails
  Scenario Outline: AMS_SOAP2REST - Null ContractParameters for <TermID>
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteAllContractsWithAccNumber')
    Given path '/recordContract'
    And request TOSRecordContractRequest
    * set TOSRecordContractRequest.contractSpecification[0].contractParameter = null
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID

    Given path '/getContract'
    And request GetContractRequest
    * set GetContractRequest.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains "ACCEPTED"
    And match response contains "<OrderId>"

    Given path '/queryContract'
    And request QueryContractRequest
    * set QueryContractRequest.contractCriteria.customerIdentifier[0].value = '<AccountNumber>'
    * set QueryContractRequest.contractCriteria.termID[0] = '<TermID>'
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termID contains '<TermID>'
    And match $response[*].customerIdentifier.value contains "<AccountNumber>"
    And match $response[*].status contains "ACCEPTED"

    * def dbCall = karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgresAccepted')
    * string CONTRACT_ATTRIBUTES = dbCall.ContractInformation[0].contract_attributes
    * print CONTRACT_ATTRIBUTES
    * match CONTRACT_ATTRIBUTES == '#null'

    Given url 'https://account-api-gateway-int.as-g8.cf.comcast.net/api/account/v1/accountmanagement/billarrangement'
    And request GetBillArrangementRequest
    And header Authorization = AMSAuth.AMSAuthorization
    When method POST
    Then status 200
    And match response[0].billingArrangementID == "<AccountNumber>"

    Examples:
      | AccountNumber    | OrderId | TermID                 |
      | 8919100012545373 | 888888  | TOS_LEARN_MORE_BTV_RSN |

  @P2K @AMS_SOAP2REST
  Scenario Outline: AMS_SOAP2REST - Few ContractParameters for <TermID>
    *  karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteAllContractsWithAccNumber')
    Given path '/recordContract'
    And request TOSRecordContractRequest
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response.recordedContractSummary[0].contractID

    Given path '/getContract'
    And request GetContractRequest
    * set GetContractRequest.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains "ACCEPTED"
    And match response contains "<OrderId>"

    Given path '/queryContract'
    And request QueryContractRequest
    * set QueryContractRequest.contractCriteria.customerIdentifier[0].value = '<AccountNumber>'
    * set QueryContractRequest.contractCriteria.termID[0] = '<TermID>'
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match $response[*].termID contains '<TermID>'
    And match $response[*].customerIdentifier.value contains "<AccountNumber>"
    And match $response[*].status contains "ACCEPTED"

    * def dbCall = karate.call('classpath:service/Regression/util/PGDatabase.feature@readRowsPostgresAccepted')
    * string CONTRACT_ATTRIBUTES = dbCall.ContractInformation[0].contract_attributes
    * print CONTRACT_ATTRIBUTES

    Given url 'https://account-api-gateway-int.as-g8.cf.comcast.net/api/account/v1/accountmanagement/billarrangement'
    And request GetBillArrangementRequest
    And header Authorization = AMSAuth.AMSAuthorization
    When method POST
    Then status 200
    And match response[0].billingArrangementID == "<AccountNumber>"
    And match $CONTRACT_ATTRIBUTES[*].value !contains response[0].billingPersonName.firstName
    And match $CONTRACT_ATTRIBUTES[*].value !contains response[0].billingPersonName.lastName
    And match $CONTRACT_ATTRIBUTES[*].value contains TOSRecordContractRequest.contractSpecification[0].contractParameter[0].value
    And match $CONTRACT_ATTRIBUTES[*].value contains TOSRecordContractRequest.contractSpecification[0].contractParameter[1].value


    Examples:
      | AccountNumber    | OrderId | TermID                 |
      | 8919100012545373 | 888888  | TOS_LEARN_MORE_BTV_RSN |