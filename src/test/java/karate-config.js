function() {
    var env = karate.env;
    karate.log('karate.env system property was:', env); // get java system property 'karate.env'
    karate.configure("ssl", true);
    karate.configure('logPrettyRequest', true);
    karate.configure('logPrettyResponse', true);

    if (!env) {
        env = 'qa';
    }
    var config = {
        env: env,
        envCheck: 'envCheck',
        serviceName: karate.properties['karate.servicename'],
        CoreTablesLocal: karate.properties['karate.coreTablesLocal'],
        config_password: karate.properties['karate.configpassword'],
        authType: karate.properties['karate.auth'],
        CoreDB_URL: 'jdbc:postgresql://xcp-core-lower-db.cluster-ctrxfl7kodaf.us-east-2.rds.amazonaws.com:5432/xcpcoreqa?currentSchema=cms',
        DB_URL: 'jdbc:postgresql://xcp-lower-cmt-db.cluster-ctrxfl7kodaf.us-east-2.rds.amazonaws.com:5432/cmtqa?currentSchema=cms',
        OAUTH_URL: 'https://sat-ci.codebig2.net/v2/ws/token.oauth2',
        //      Uncomment the following to hit via Gateway - XCP
        //      Endpoint_REST: 'https://xcp-api-gateway-qa.as-g8.cf.comcast.net/api/customer/v1/contractmanagement',
        Endpoint_Env: 'https://contract-management-service-qa.as-g8.cf.comcast.net/env',
        Endpoint_REST: 'https://contract-management-service-qa.as-g8.cf.comcast.net/api/customer/v1/contractmanagement',
        Endpoint_REST_CMT: 'https://contract-cmt-qa.as-g8.cf.comcast.net/api/v1/contract/',
        Endpoint_Platco: 'https://contract-management-service-qa.as-g8.cf.comcast.net/api/customer/v1/contract',
        Endpoint_Platco_INT: 'https://contract-management-service-int.as-g8.cf.comcast.net/api/customer/v1/contract',
        Endpoint_REST_ProdCode: 'https://contract-management-service-cassandra-code-qa.as-g8.cf.comcast.net/api/customer/v1/contractmanagement'
    };

    if (config.serviceName == 'cms' && env == 'qa') {
        var result = karate.callSingle('classpath:service/Regression/espConfigServer.feature@qa',config);
        config.db_username = result.db_username;
        config.db_password = result.db_password;
        config.cmt_db_username = result.cmt_db_username;
        config.cmt_db_password = result.cmt_db_password;
        config.client_id = result.client_id;
        config.client_pass = result.client_pass;
        config.recon_client_pass = result.recon_client_pass;

        var tokenRefreshTimeInMinutes = 100;
        var OAUTH_URL_API;
        var myToken = {};
        var KarateCache = Java.type('KarateCache');
        var lastRefreshTime = KarateCache.get('lastRefreshTime');
        var dif = (new Date() - new Date(lastRefreshTime));
        karate.log('dif',dif);
        var difMins = Math.round((dif / 1000) / 60);
        karate.log('lastRefreshTime',lastRefreshTime);
        karate.log('difMins',difMins);
        if (!lastRefreshTime || difMins >= tokenRefreshTimeInMinutes) {
            OAUTH_URL_API = karate.call('classpath:service/Regression/RestClient.feature@restclient',config);
            config.Authorization = OAUTH_URL_API.Authorization;
            KarateCache.add('lastRefreshTime', new Date().toUTCString());
            KarateCache.add('Authorization', OAUTH_URL_API.Authorization);
            karate.log('Generated New Token by hitting OAUTH_URL: IF CASE');
        }
        else {
            config.Authorization = KarateCache.get('Authorization');
            karate.log('Used Existing Token from KarateCache: ELSE CASE');
        }
//        var OAUTH_URL_API = karate.callSingle('classpath:service/Regression/RestClient.feature@restclient',config);
//        config.Authorization = OAUTH_URL_API.Authorization;
        var envAPI = karate.callSingle('classpath:service/Regression/envCheck.feature@envCheck',config);
        config.envCheck = envAPI;
    }

    if (config.CoreTablesLocal == 'Y' && env == 'qa') {
        config.CoreDB_URL = 'jdbc:postgresql://localhost:5432/xcpcoreqa?currentSchema=cms';
        config.DB_URL = 'jdbc:postgresql://localhost:6432/cmtqa?currentSchema=cms';
    }

    if (env != 'qa') {
        var result = karate.callSingle('classpath:service/Regression/espConfigServer.feature@prod',config);
        config.DB_URL = 'jdbc:postgresql://xcp-contract-cmt-prd-db.cluster-cavh8sk1spm6.us-east-1.rds.amazonaws.com/contract?currentSchema=cms&targetServerType=primary';
        config.CoreDB_URL = 'jdbc:postgresql://xcp-contract-core-prd-db.cluster-cavh8sk1spm6.us-east-1.rds.amazonaws.com:5432/contract?currentSchema=cms';
        config.db_username = result.db_username;
        config.db_password = result.db_password;
        config.cmt_db_username = result.cmt_db_username;
        config.cmt_db_password = result.cmt_db_password;
        config.client_id = result.client_id;
        config.client_pass = result.client_pass;
        config.cmt_client_id = result.cmt_client_id;
        config.cmt_secret = result.cmt_client_pass;
        config.OAUTH_URL = 'https://sat-prod.codebig2.net/v2/ws/token.oauth2';
        config.CMTURL = 'https://contract-cmt.xsp.comcast.net/api/v1/contract/';

        if (env == 'po-g2') {
            config.Endpoint_REST = 'https://ContractManagementService-generic-prd-canary.po-g2.cf.comcast.net/api/customer/v1/contractmanagement';
            config.Endpoint_Env = 'https://ContractManagementService-generic-prd-canary.po-g2.cf.comcast.net/env';
        }
        else if (env == 'wc-g2') {
            config.Endpoint_REST = 'https://ContractManagementService-generic-prd-canary.wc-g2.cf.comcast.net/api/customer/v1/contractmanagement';
            config.Endpoint_Env = 'https://ContractManagementService-generic-prd-canary.wc-g2.cf.comcast.net/env';
        }
        else if (env == 'as-g6') {
            config.Endpoint_REST = 'https://ContractManagementService-generic-prd-canary.as-g6.cf.comcast.net/api/customer/v1/contractmanagement';
            config.Endpoint_Env = 'https://ContractManagementService-generic-prd-canary.as-g6.cf.comcast.net/env';
        }
        else if (env == 'as-g7') {
            config.Endpoint_REST = 'https://ContractManagementService-generic-prd-canary.as-g7.cf.comcast.net/api/customer/v1/contractmanagement';
            config.Endpoint_Env = 'https://ContractManagementService-generic-prd-canary.as.g7.cf.comcast.net/env';
        }
        else if (env == 'ch2-g1') {
            config.Endpoint_REST = 'https://ContractManagementService-generic-prd-canary.ch2-g1.cf.comcast.net/api/customer/v1/contractmanagement';
            config.Endpoint_Env = 'https://ContractManagementService-generic-prd-canary.ch2-g1.cf.comcast.net/env';
        }
        else if (env == 'ho-g3') {
            config.Endpoint_REST = 'https://ContractManagementService-generic-prd-canary.ho-g3.cf.comcast.net/api/customer/v1/contractmanagement';
            config.Endpoint_Env = 'https://ContractManagementService-generic-prd-canary.ho-g3.cf.comcast.net/env';
        }
        else if (env == 'g2') {
            config.Endpoint_REST = 'https://ContractManagementService-generic-prd-canary.g2.app.cloud.comcast.net/api/customer/v1/contractmanagement';
            config.Endpoint_Env = 'https://ContractManagementService-generic-prd-canary.g2.app.cloud.comcast.net/env';
        }
        else if (env == 'g3') {
            config.Endpoint_REST = 'https://ContractManagementService-generic-prd-canary.g3.app.cloud.comcast.net/api/customer/v1/contractmanagement';
            config.Endpoint_Env = 'https://ContractManagementService-generic-prd-canary.g3.app.cloud.comcast.net/env';
        }
        else if (env == 'hog3'){
            config.Endpoint_REST = 'https://contract-management-service-prd.ho-g3.cf.comcast.net/api/customer/v1/contractmanagement';
            config.Endpoint_Env = 'https://contract-management-service-prd.ho-g3.cf.comcast.net/env';
        }
        else if (env == 'ch2g1'){
            config.Endpoint_REST = 'https://contract-management-service-prd.ch2-g1.cf.comcast.net/api/customer/v1/contractmanagement';
            config.Endpoint_Env = 'https://contract-management-service-prd.ch2-g1.cf.comcast.net/env';
        }
        else if (env == 'pog2'){
            config.Endpoint_REST = 'https://contract-management-service-prd.po-g2.cf.comcast.net/api/customer/v1/contractmanagement';
            config.Endpoint_Env = 'https://contract-management-service-prd.po-g2.cf.comcast.net/env';
        }
        else if (env == 'asg6'){
            config.Endpoint_REST = 'https://contract-management-service-prd.as-g6.cf.comcast.net/api/customer/v1/contractmanagement';
            config.Endpoint_Env = 'https://contract-management-service-prd.as-g6.cf.comcast.net/env';
        }
        else if (env == 'asg7'){
            config.Endpoint_REST = 'https://contract-management-service-prd.as-g7.cf.comcast.net/api/customer/v1/contractmanagement';
            config.Endpoint_Env = 'https://contract-management-service-prd.as-g7.cf.comcast.net/env';
        }
        else if (env == 'wcg2'){
            config.Endpoint_REST = 'https://contract-management-service-prd.wc-g2.cf.comcast.net/api/customer/v1/contractmanagement';
            config.Endpoint_Env = 'https://contract-management-service-prd.wc-g2.cf.comcast.net/env';
        }
        else if (env == 'g-2'){
            config.Endpoint_REST = 'https://contract-management-service-prd.g2.app.cloud.comcast.net/api/customer/v1/contractmanagement';
            config.Endpoint_Env = 'https://contract-management-service-prd.g2.app.cloud.comcast.net/env';
        }
        else if (env == 'g-3'){
            config.Endpoint_REST = 'https://contract-management-service-prd.g3.app.cloud.comcast.net/api/customer/v1/contractmanagement';
            config.Endpoint_Env = 'https://contract-management-service-prd.g3.app.cloud.comcast.net/env';
        }
        else if (env == 'xsp') config.Endpoint_REST = 'https://contract-management-service.xsp.comcast.net/api/customer/v1/contractmanagement';
        else if (env == 'xcp-xsp') config.Endpoint_REST = 'https://xcp-api-gateway.xsp.comcast.net/api/customer/v1/contractmanagement';
    }
    karate.configure('connectTimeout', 1500000);
    karate.configure('readTimeout', 1500000);
    karate.configure('pauseIfNotPerf', true);
    karate.configure('abortedStepsShouldPass',true);
    return config;
}
