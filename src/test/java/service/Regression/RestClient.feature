Feature: Rest Client

  Background:
    * url OAUTH_URL

  @restclient
  Scenario: OAUTH2 Authentication
    * form field client_id = client_id
    * form field client_secret = client_pass
    * form field grant_type = 'client_credentials'
    * form field scope = 'esp:contractManagement'
    * method post
    * status 200
    * def accessToken = response.access_token
    * def Authorization = 'Bearer ' + accessToken
#    * def Authorization = 'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IkpXVFNpZ25pbmdDZXJ0LTIwMjAtTExFIiwieDV0IjoiVFRXME5hRHVsdmZ5SUxXand0ZTZmaE5HeURRIiwicGkuYXRtIjoiNSJ9.eyJzY29wZSI6WyJlc3A6Y29udHJhY3RNYW5hZ2VtZW50Il0sImNsaWVudF9pZCI6InhjcC1jb250cmFjdC0xIiwiaXNzIjoiaHR0cHM6Ly93ZWJzZWMtaW50LmNhYmxlLmNvbWNhc3QuY29tIiwiZXhwIjoxNjY1MTM3NzkyfQ.eL52jKdn9puMRXDPJ8jVKPcwrTMnFqwkydDc2hxr_HV8Uptf3abCj3TEx4JGRPNZsMxfNFit2xhR97DUumzuVFZjCQ6f2E6RN8A4ahXLySghQIKymdKWvNHccoMkWQutbQmCWlQRqhJIXkAoHNq51bawl-sNbNk0cR7ES2E-A_H0PjAmWCW66quwRabJ4dVtszsb469_gqHCPhBRXBuwyqexZk3lFFbal9TCSj0V1lZc-V218KRrD60Q0i5MbPRas0drStQ-p56urwbZK8JWbJ20Z-n6x790Ik-PjYgoh3dsHHHmkz8CYLEqgZlvzfkidkSSZHPwIbJ8ylij8FKUfA'

  @restclientRecon
  Scenario: OAUTH2 Authentication
    * form field client_id = 'cmsreconuser'
    * form field client_secret = recon_client_pass
    * form field grant_type = 'client_credentials'
    * form field scope = 'esp:contractManagement'
    * method post
    * status 200
    * def accessToken = response.access_token
    * def ReconAuthorization = 'Bearer ' + accessToken

  @OAUTH2AMS
  Scenario: OAUTH2 Authentication for AMS
    * form field client_id = client_id
    * form field client_secret = client_pass
    * form field grant_type = 'client_credentials'
    * form field scope = 'xsp:account'
    * method post
    * status 200
    * def accessToken = response.access_token
    * def AMSAuthorization = 'Bearer ' + accessToken

  @OAUTH2CMT
  Scenario: OAUTH2 - TOS Consolidation
    * form field client_id = client_id
    * form field client_secret = client_pass
    * form field grant_type = 'client_credentials'
    * form field scope = 'xcp:cmt:contract:write xcp:cmt:contract:read xcp:cmt:contract:update xcp:cmt:contract:delete'
    * method post
    * status 200
    * def accessToken = response.access_token
    * def CMTAuthorization = 'Bearer ' + accessToken

  @OAUTH2Platco
  Scenario: Platco OAUTH2
    * form field client_id = 'xcpplatcouser'
    * form field client_secret = 'xcpuserpwd'
    * form field grant_type = 'client_credentials'
    * form field scope = 'xcp:cmt:contract:write xcp:cmt:contract:read xcp:cmt:contract:update xcp:cmt:contract:delete'
    * method POST
    * status 200
    * print response
    * def accessToken = response.access_token
    * print accessToken
    * def PlatcoAuthorization = 'Bearer ' + accessToken

  @OAUTH2PlatcoFTS
  Scenario: Platco FTS OAUTH2
    * form field client_id = 'xcpplatcouser'
    * form field client_secret = 'xcpuserpwd'
    * form field grant_type = 'client_credentials'
    * form field scope = 'xcp:cmt:contract:read xcp:cmt:customer-relationship:read sa:xglobal:read billing:account:retrievebillingaccount'
    * method POST
    * status 200
    * print response
    * def accessToken = response.access_token
    * print accessToken
    * def PlatcoFTSAuthorization = 'Bearer ' + accessToken
