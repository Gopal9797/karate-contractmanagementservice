Feature: Core Table Connection

  Background:
    * def DbUtils = Java.type('service.Regression.util.PostgresDbUtils')
    * def configuration = { username: '#(db_username)', password: '#(db_password)', url: '#(CoreDB_URL)', driverClassName: 'org.postgresql.Driver' }
    * def javaDBMethods = new DbUtils(configuration)
#  jdbc:postgresql://localhost:5432/xcpcoreqa?currentSchema=cms
#  jdbc:postgresql://xcp-core-lower-db.cluster-ctrxfl7kodaf.us-east-2.rds.amazonaws.com:5432/xcpcoreqa?currentSchema=cms

#  Below three steps I do to connect to AWS from local
#  jump ec2-user@10.141.0.9 -- -nNT -L 7777:127.0.0.1:22 -vvv
#  ssh -L 5432:xcp-core-lower-db.cluster-ctrxfl7kodaf.us-east-2.rds.amazonaws.com:5432 -N -vvv -p 7777 ec2-user@localhost
#  spring.datasource.url=jdbc:postgresql://localhost:5432/xcpcoreqa?currentSchema=cms has context menu

  @coreTableValidation @async_operations_log
  Scenario: Retrieves async_operations_log Information
    * print 'Query:', query
#    * def queryArg = '#(query)'
#    * prtin 'QueryArg:', queryArg
    * print 'DB URL:', CoreDB_URL
    * def async_operations_log = javaDBMethods.readRowsPostgres(query)
    * print async_operations_log

  @coreTableValidation @cms_technician_detail
  Scenario: Retrieves cms_technician_detail Information
    * print 'Query:', query
    * print 'DB URL:', CoreDB_URL
    * def cms_technician_detail = javaDBMethods.readRowsPostgres(query)
    * print cms_technician_detail

  @coreTableValidation @cms_user_audit_log
  Scenario: Retrieves cms_user_audit_log Information
    * print 'DB URL:', CoreDB_URL
    * def cms_user_audit_log = javaDBMethods.readRowsPostgres("select * from cms.cms_user_audit_log;")
    * print cms_user_audit_log

  @coreTableValidation @xhs_users
  Scenario: Retrieves xhs_users Information
    * print 'DB URL:', CoreDB_URL
    * def xhs_users = javaDBMethods.readRowsPostgres("select * from cms.xhs_users;")
    * print xhs_users

  @coreTableValidation @cms_service_conf_parameters
  Scenario: Retrieves cms_service_conf_parameters Information
    * print 'DB URL:', CoreDB_URL
    * def cms_service_conf_parameters = javaDBMethods.readRowsPostgres("select * from cms.cms_service_conf_parameters;")
    * print cms_service_conf_parameters

  @coreTableValidation @CMS_SERVICE_CONF_ATTRIBUTES
  Scenario: Retrieves CMS_SERVICE_CONF_ATTRIBUTES Information
    * print 'DB URL:', CoreDB_URL
    * def CMS_SERVICE_CONF_ATTRIBUTES = javaDBMethods.readRowsPostgres("select * from cms.CMS_SERVICE_CONF_ATTRIBUTES;")
    * print CMS_SERVICE_CONF_ATTRIBUTES

  @coreTableValidation @cms_terms_of_service_conf
  Scenario: Retrieves cms_terms_of_service_conf Information
    * print 'DB URL:', CoreDB_URL
    * def cms_terms_of_service_conf = javaDBMethods.readRowsPostgres("select * from cms.cms_terms_of_service_conf;")
    * print cms_terms_of_service_conf

  @coreTableValidation @cms_fulfillment_status_log
  Scenario: Retrieves cms_fulfillment_status_log Information
    * print 'DB URL:', CoreDB_URL
    * def cms_fulfillment_status_log = javaDBMethods.readRowsPostgres("select * from cms.cms_fulfillment_status_log;")
    * print cms_fulfillment_status_log

  @coreTableValidation @cms_metrics
  Scenario: Retrieves cms_metrics Information
    * print 'DB URL:', CoreDB_URL
    * def cms_metrics = javaDBMethods.readRowsPostgres("select * from cms.cms_metrics;")
    * print cms_metrics

  @coreTableValidation @term_id_reference
  Scenario: Retrieves term_id_reference Information
    * print 'DB URL:', CoreDB_URL
    * print 'Query:', query
    * def term_id_reference = javaDBMethods.readRowsPostgres(query)
    * print term_id_reference

  @coreTableValidation @term_id_referenceDelete
  Scenario: Deletes term_id_reference Information
    * print 'DB URL:', CoreDB_URL
    * print 'Query:', query
    * def term_id_reference = javaDBMethods.deleteRowsPostgres(query)
    * print term_id_reference

  @coreTableValidation @term_rate_code_xref
  Scenario: Retrieves term_rate_code_xref Information
    * print 'DB URL:', CoreDB_URL
    * def term_rate_code_xref = javaDBMethods.readRowsPostgres("select * from cms.term_rate_code_xref;")
    * print term_rate_code_xref

