Feature: AMS - SOAP2REST - SubmitContract

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '#(global_extension.currentTime)', sourceServerId: 'karate', trackingId: '#(global_extension.trackingTime)'}
    * url Endpoint_REST
    * def SubmitContractRequest = read('SubmitContractRequest.json')
    * def GetContractRequest = read('GetContractRequest.json')
    * def QueryContractRequest = read('QueryContractRequest.json')
    * def GetBillArrangementRequest = read('GetBillArrangementRequest.json')
    * def AMSAuth = karate.call('classpath:service/Regression/RestClient.feature@OAUTH2AMS')

  @SubmitContract @AMS_SOAP2REST
  Scenario Outline: AMS_SOAP2REST - Without Required list ContractParameters for <TermID>
    * def AccountNumber = <AccountNumber>
    * karate.call('classpath:service/Regression/util/PGDatabase.feature@deleteAllContractsWithAccNumber')

    Given path '/queryContract'
    * set QueryContractRequest.contractCriteria.customerIdentifier[0].value = "<AccountNumber>"
    And request QueryContractRequest
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response == []

    Given path '/submitContract'
    And request SubmitContractRequest
    * set SubmitContractRequest.accountNumber = "<AccountNumber>"
    And header Authorization = Authorization
    When method POST
    Then status 200
    * karate.pause(40000)

    Given path '/queryContract'
    * set QueryContractRequest.contractCriteria.customerIdentifier[0].value = "<AccountNumber>"
    And request QueryContractRequest
    And header Authorization = Authorization
    When method POST
    Then status 200
    * def contractID = response[0].contractID

    Given path '/getContract'
    And request GetContractRequest
    * set GetContractRequest.contractID[0] = contractID
    And header Authorization = Authorization
    When method POST
    Then status 200
    And match response contains "PRESENTED"
    And match response contains "<OrderId>"

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
      | 8919100012453149 | 98765   | TP_VIP_X1Premier_200_$159.99x24_2Y_Q416_230ETF_SelfServ | BA         |
      | 8919100012453149 | 87654   | XH_EIP_2Y_Q119_COMP                                     | ST276      |
      | 8919100012453149 | 76543   | SP_INTERNET_25_VA                                       | OT945      |