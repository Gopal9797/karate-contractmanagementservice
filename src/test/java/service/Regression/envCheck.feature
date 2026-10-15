Feature: Environment Check

  Background:
    * def global_extension = call read('classpath:extension_tool.feature')
    * configure headers = {sourceSystemId: 'karate', sourceSystemUserId: 'karate', timestamp: '2022-03-29T18:54:00.035Z', sourceServerId: 'karate', trackingId: #(currentTime)}

  @envCheck
  Scenario: To Check the Environment
    * def restClient = call read('classpath:service/Regression/RestClient.feature@restclient')
    Given url Endpoint_Env
    And header Authorization = restClient.Authorization
    When method get
    Then status 200
#    * def ContractCMTWriteFlag = response.propertySources[6].properties["contractcmt.write.flag"].value
#    * def ContractCMTReadFlag = response.propertySources[6].properties["contractcmt.read.flag"].value
#    * def CoreTablesReadFlag = response.propertySources[6].properties["core.table.read.flags"].value
#    * def CoreTablesWriteFlag = response.propertySources[6].properties["core.table.write.flags"].value
#    * print 'ContractCMTWriteFlag', ContractCMTWriteFlag
#    * print 'ContractCMTReadFlag', ContractCMTReadFlag
#    * print 'CoreTablesReadFlag', CoreTablesReadFlag
#    * print 'CoreTablesWriteFlag', CoreTablesWriteFlag

