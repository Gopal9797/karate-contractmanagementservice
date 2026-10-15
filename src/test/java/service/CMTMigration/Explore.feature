Feature: Explore

  Background:
#  gradlew test -Dkarate.options="--tags @regexExplore"
  @regexExplore
  Scenario: Regex Explore
    * def DbUtils = Java.type('service.Regression.util.DbUtils')
    * def configuration = { username: 'cmsapi', password: '', url: 'xcpdb-1q-ch2-075200.sys.comcast.net', driverClassName: 'datastax' }
    * def javaDBMethods = new DbUtils(configuration)
    * def value = "2deab310-a5d0-11ed-8ffa-5d1a8a3ef1c4, OT695, WEB, updated_ts:1675654906050, contract_attribute_guid:'526940ad2b314ab89125c6ed152b1494',created_by:'xcp-contract-1',created_ts:1675654906050},"
    * def afterValue = javaDBMethods.ReplaceAllNeededValues(value)
    * print afterValue

#  gradlew test -Dkarate.options="--tags @explore"
  @explore
  Scenario Outline: Explore Karate '<contract_id>'
#    CONTRACT_ATTRIBUTES COMPARISON:
    * json contract_attributes_Scenario3 = karate.sort(<contract_attributes_Scenario3>, x => x.name)
    * print contract_attributes_Scenario3


    * json contract_attributes_Scenario2 = karate.sort(<contract_attributes_Scenario2>, x => x.name)
    * print contract_attributes_Scenario2
#    * karate.set($contract_attributes_Scenario3[*].created_timestamp,'#present')
#    * karate.set($contract_attributes_Scenario3[*].modified_timestamp,'#present')
#    * def contract_attributes_Scenario3After = contract_attributes_Scenario3.map(x => ({ created_timestamp: x.created_timestamp * 0 }))
#    * print contract_attributes_Scenario3After
#    * def contract_attributes_Scenario2After = contract_attributes_Scenario2.map(x => ({ created_timestamp: 'x.created_timestamp * 0  }))
#    * print contract_attributes_Scenario2After
#    * karate.set($contract_attributes_Scenario2[*].created_timestamp,'#present')
#    * karate.set($contract_attributes_Scenario2[*].modified_timestamp,'#present')
#    * match contract_attributes_Scenario2 == contract_attributes_Scenario3


#    INCENTIVE_FULFILLMENT_STATUS COMPARISON
    * json incentive_fulfillment_statuses_Scenario3 = karate.sort(<incentive_fulfillment_statuses_Scenario3>, x => x.fulfillment_status_code)
    * print incentive_fulfillment_statuses_Scenario3
#    * json FFSA = $incentive_fulfillment_statuses_Scenario3[*].fulfillment_status_attributes
#    * print incentive_fulfillment_statuses_Scenario3[*].fulfillment_status_attributes
#    * def FFSA_After = FFSA
    * def FFSA_Len = $incentive_fulfillment_statuses_Scenario3[*].fulfillment_status_attributes.length
    * print FFSA_Len
    * def fun = function(i){ if(($incentive_fulfillment_statuses_Scenario3[*].fulfillment_status_attributes[i]) != '[]')karate.sort(($incentive_fulfillment_statuses_Scenario3[*].fulfillment_status_attributes[i]), x => x.status_attribute_name) }
    * def foo = karate.repeat(FFSA_Len, fun)
#    * print incentive_fulfillment_statuses_Scenario3[*].fulfillment_status_attributes
#    * set incentive_fulfillment_statuses_Scenario3[*].fulfillment_status_attributes = FFSA_After
    * print incentive_fulfillment_statuses_Scenario3

    * json incentive_fulfillment_statuses_Scenario2 = karate.sort(<incentive_fulfillment_statuses_Scenario2>, x => x.fulfillment_status_code)
    * print incentive_fulfillment_statuses_Scenario2
#    * json FFSA = $incentive_fulfillment_statuses_Scenario2[*].fulfillment_status_attributes
#    * print incentive_fulfillment_statuses_Scenario2[*].fulfillment_status_attributes
#    * def FFSA_After = FFSA
    * def FFSA_Len = $incentive_fulfillment_statuses_Scenario2[*].fulfillment_status_attributes.length
    * print FFSA_Len
    * def fun = function(i){ if(($incentive_fulfillment_statuses_Scenario2[*].fulfillment_status_attributes[i]) != '[]')karate.sort(($incentive_fulfillment_statuses_Scenario2[*].fulfillment_status_attributes[i]), x => x.status_attribute_name) }
    * def foo = karate.repeat(FFSA_Len, fun)
#    * print incentive_fulfillment_statuses_Scenario2[*].fulfillment_status_attributes
#    * set incentive_fulfillment_statuses_Scenario2[*].fulfillment_status_attributes = FFSA_After
    * print incentive_fulfillment_statuses_Scenario2

    * match incentive_fulfillment_statuses_Scenario2 == incentive_fulfillment_statuses_Scenario3
    * match contract_attributes_Scenario2 == contract_attributes_Scenario3

    Examples:
      | read('S2S3_Contract.csv') |


  @explore2
  Scenario Outline: Explore Karate '<contract_id>'
    * match <contract_attributes_Scenario3> == <contract_attributes_Scenario2>
    * match <incentive_fulfillment_statuses_Scenario3> == <incentive_fulfillment_statuses_Scenario2>

    #    INCENTIVE_FULFILLMENT_STATUS COMPARISON
    * json incentive_fulfillment_statuses_Scenario3 = karate.sort(<incentive_fulfillment_statuses_Scenario3>, x => x.fulfillment_status_code)
    * print incentive_fulfillment_statuses_Scenario3
    * json FFSA = $incentive_fulfillment_statuses_Scenario3[*].fulfillment_status_attributes
    * print FFSA
    * def FFSA_After = FFSA
    * def FFSA_Len = FFSA.length
    * print FFSA_Len
    * def fun = function(i){ if(FFSA_After[i] != '[]')karate.sort(FFSA_After[i], x => x.status_attribute_name) }
    * def foo = karate.repeat(FFSA_Len, fun)
    * print FFSA_After
    * set incentive_fulfillment_statuses_Scenario3[*].fulfillment_status_attributes = FFSA_After
    * print incentive_fulfillment_statuses_Scenario3

    * json incentive_fulfillment_statuses_Scenario2 = karate.sort(<incentive_fulfillment_statuses_Scenario2>, x => x.fulfillment_status_code)
    * print incentive_fulfillment_statuses_Scenario2
    * json FFSA = $incentive_fulfillment_statuses_Scenario2[*].fulfillment_status_attributes
    * print FFSA
    * def FFSA_After = FFSA
    * def FFSA_Len = FFSA.length
    * print FFSA_Len
    * def fun = function(i){ if(FFSA_After[i] != '[]')karate.sort(FFSA_After[i], x => x.status_attribute_name) }
    * def foo = karate.repeat(FFSA_Len, fun)
    * set incentive_fulfillment_statuses_Scenario2[*].fulfillment_status_attributes = FFSA_After
    * print incentive_fulfillment_statuses_Scenario2

    Examples:
      | read('S2S3_Contract.csv') |

#  gradlew test -Dkarate.options="--tags @assertionExplore"
  @assertionExplore
  Scenario: Check for Assertion
    * def value = 'ACCEPTED'
    And match ['ACCEPTED','PRESENTED'] contains value
    * def value = 'PRESENTED'
    And match ['ACCEPTED','PRESENTED'] contains value

#  gradlew test -Dkarate.options="--tags @concateExplore"
  @concateExplore
  Scenario: Check for concatenation
    * def queryResult_0 =
   """
  [
  {
  "DELIVERED_PRODUCT_GUID": "F0F96CB29A764C3FE053A44C920AC8CA",
  "DELIVERED_PRODUCT_TYPE_CD": "EQPMT",
  "DELIVERY_PLATFORM_CD": "IMS",
  "EPC_PRODUCT_NUM": "8000029",
  "OUTLET_NM": "1",
  "LINE_OF_BUSINESS_TYPE_CD": "HSD",
  "LIFECYCLE_CD": "PRVSN",
  "PARTY_SERVICE_LOCATION_GUID": "F0F96CB29A734C3FE053A44C920AC8CA",
  "DLVRD_PROD_STATUS_TYPE_CD": "ACTV",
  "IMS_SUBSCRIPTION_ID": "97222",
  "DELIVERED_PRODUCT_START_DTT": "2022-12-30 02:48:15.937",
  "DELIVERED_PRODUCT_END_DTT": "2022-12-30 07:48:25.209508",
  "AUDIT_CREATED_BY_USER_ID": "crs_service"
  }
  ]
    """

    * def queryResult_1 =
   """
  [
  {
  "DELIVERED_PRODUCT_GUID": "F0F96CB29A804C3FE053A44C920AC8CA",
  "DELIVERED_PRODUCT_TYPE_CD": "PRDGRP",
  "DELIVERY_PLATFORM_CD": "IMS",
  "EPC_PRODUCT_NUM": "8000014",
  "OUTLET_NM": "1",
  "LINE_OF_BUSINESS_TYPE_CD": "HSD",
  "LIFECYCLE_CD": "PRVSN",
  "PARTY_SERVICE_LOCATION_GUID": "F0F96CB29A734C3FE053A44C920AC8CA",
  "DLVRD_PROD_STATUS_TYPE_CD": "ACTV",
  "IMS_SUBSCRIPTION_ID": "97222",
  "AUDIT_CREATED_BY_USER_ID": "crs_service",
  "AUDIT_CREATED_TS": "2022-12-30 13:18:13.641",
  "AUDIT_UPDATED_BY_USER_ID": "crs_service",
  "AUDIT_UPDATED_TS": "2022-12-30 13:18:15.955"
  }
  ]
    """
    * def finalResult = karate.append(queryResult_0 , queryResult_1)
    * print 'FINAL RESULT', finalResult
    * match $finalResult[*].* contains "crs_service"

#  gradlew test -Dkarate.options="--tags @exploreMatchAssertion"
  @exploreMatchAssertion
  Scenario:Assertion Exploration
    * def str1 = "ACCEPTED"
    * def assertionStatus =
    """
    function(s) {
    const conditions = ["PRESENTED", "ACCEPTED"];
    const test1 = conditions.some(el => s.includes(el));
    return test1;
    }
    """
    * def assertionPrint = assertionStatus(str1)
    * print assertionPrint
    * match assertionPrint == true