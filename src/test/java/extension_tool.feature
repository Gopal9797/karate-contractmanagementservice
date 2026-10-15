Feature: Generate a random session id

  Background:
    * def assertionStatus =
    """
    function(s) {
    const conditions = ["PRESENTED", "ACCEPTED"];
    const test1 = conditions.some(el => s.includes(el));
    return test1;
    }
    """

    * def randomNumber =
    """
    function(s) {
    var text = "";
    var possible = "1234567890";
    for (var i = 0; i < s; i++)
    text += possible.charAt(Math.floor(Math.random() * possible.length));
    return text;
    }
    """

    * def getDate =
    """
    function() {
    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
    var sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    var date = new java.util.Date();
    return sdf.format(date);
    }
    """

    * def getDateInTimestamp =
    """
    function() {
    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
    var sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    var date = new java.util.Date();
    return sdf.format(date);
    }
    """


    * def getTodayDate =
    """
    function() {
    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
    var sdf = new SimpleDateFormat("yyyy-MM-dd");
    var date = new java.util.Date();
    return sdf.format(date);
    }
    """

    * def getTodayDateISO =
    """
    function() {
    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
    var sdf = new SimpleDateFormat("yyyy-MM-dd'T'00:00:00.000'Z'");
    var date = new java.util.Date();
    return sdf.format(date);
    }
    """

    * def getTodayDatePlus3Years =
    """
    function() {
    var currentDate = new Date();
    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
    var sdf = new SimpleDateFormat("yyyy-MM-dd");
    var todayplus3years = currentDate.setFullYear(currentDate.getFullYear() + 3);
    return sdf.format(todayplus3years);
    }
    """

    * def getTodayDatePlus2Years =
    """
    function() {
    var currentDate = new Date();
    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
    var sdf = new SimpleDateFormat("yyyy-MM-dd");
    var todayplus2years = currentDate.setFullYear(currentDate.getFullYear() + 2);
    return sdf.format(todayplus2years);
    }
    """

    * def getTodayDatePlus3YearsISO =
    """
    function() {
    var currentDate = new Date();
    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
    var sdf = new SimpleDateFormat("yyyy-MM-dd'T'00:00:00.000'Z'");
    var todayplus2years = currentDate.setFullYear(currentDate.getFullYear() + 3);
    return sdf.format(todayplus2years);
    }
    """

    * def now =
    """
    function(){ return java.lang.System.currentTimeMillis() }
    """

    * def fiveDaysBeforeFn =
    """
    function() {
    var currentDate = new Date();
    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat')
    var sdf = new SimpleDateFormat("yyyy-MM-dd");
    var yesterday = currentDate.setDate(currentDate.getDate() - 5);
    return sdf.format(yesterday)
    }
    """

    * def fiveDaysAfterFn =
    """
    function() {
    var currentDate = new Date();
    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat')
    var sdf = new SimpleDateFormat("yyyy-MM-dd");
    var yesterday = currentDate.setDate(currentDate.getDate() + 5);
    return sdf.format(yesterday)
    }
    """
    * def fiveDaysAfterISOFn =
    """
    function() {
    var currentDate = new Date();
    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat')
    var sdf = new SimpleDateFormat("yyyy-MM-dd'T'00:00:00.000'Z'");
    var yesterday = currentDate.setDate(currentDate.getDate() + 5);
    return sdf.format(yesterday)
    }
    """


    * def fiveDaysnTwoYearsAfterFn =
    """
    function() {
    var currentDate = new Date();
    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat')
    var sdf = new SimpleDateFormat("yyyy-MM-dd");
    var fiveDaysAfter = currentDate.setDate(currentDate.getDate() + 5);
    var fiveDaysnTwoYearsAfter = currentDate.setFullYear(currentDate.getFullYear() + 2);
    return sdf.format(fiveDaysnTwoYearsAfter)
    }
    """

    * def fiveDaysnTwoYearsAfterISOFn =
    """
    function() {
    var currentDate = new Date();
    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat')
    var sdf = new SimpleDateFormat("yyyy-MM-dd'T'00:00:00.000'Z'");
    var fiveDaysAfter = currentDate.setDate(currentDate.getDate() + 5);
    var fiveDaysnTwoYearsAfter = currentDate.setFullYear(currentDate.getFullYear() + 2);
    return sdf.format(fiveDaysnTwoYearsAfter)
    }
    """

    * def tomorrow =
    """
    function() {
    var currentDate = new Date();
    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat')
    var sdf = new SimpleDateFormat("yyyy-MM-dd");
    var tomorrow = currentDate.setDate(currentDate.getDate() + 1);
    return sdf.format(tomorrow)
    }
    """
    * def Technician_Name = "TechName" + randomNumber(4)
    * def Customer_Name = "CustomerName" + randomNumber(4)
    * def Tech_Email = "Tech_Email" + randomNumber(4) + "@cable.comcast.com"
    * def Cust_Email = "Cust_Email" + randomNumber(4) + "@cable.comcast.com"
    * def Technician_Id =  randomNumber(6)
    * def Job_Id = randomNumber(5)
    * def csgCustomerId = randomNumber(13)
    * def phoneNumber = randomNumber(10)
    * def accountNumber = randomNumber(16)
    * def driversLicense = randomNumber(10)
    * def todaysDate = getTodayDate()
    * def todaysDateISO = getTodayDateISO()
    * def currentTimeInTimestamp = getDateInTimestamp()
    * def currentTime = getDate()
    * def todaysDatePlus3Years = getTodayDatePlus3Years()
    * def todaysDatePlus2Years = getTodayDatePlus2Years()
    * def todaysDatePlus3YearsISO = getTodayDatePlus3YearsISO()
    * def trackingTime = now()
    * def fiveDaysBefore = fiveDaysBeforeFn()
    * def fiveDaysAfter = fiveDaysAfterFn()
    * def fiveDaysAfterISO = fiveDaysAfterISOFn()
    * def fiveDaysnTwoYearsAfter = fiveDaysnTwoYearsAfterFn()
    * def fiveDaysnTwoYearsAfterISO = fiveDaysnTwoYearsAfterISOFn()
    * def phoneNumber = randomNumber(10)
    * def phoneNumberwithPlus = "+1" + phoneNumber
    * def EmailAddress = "emailid" + randomNumber(4) + "@gmail.com"
    * def documentURL = "https://www.comcast.com/" + randomNumber(4) + "document"
#
# # Random UUID value is generated and assigned to a variable. This is used for the deviceId value
    * def randomUUID =
    """
    function(){ return java.util.UUID.randomUUID() + '' }
    """

    * def uuid = randomUUID()
    * def uuid2 = randomUUID()
#
# # TBC
# # * def tulipReferenceGen =
#
#    # """
#    # function(s) {
#    # var text = "";
#    # var possible = "abcdefghijklmnopqrstuv1234567890";
#    # for (var i = 0; i < s; i++)
#    # text += possible.charAt(Math.floor(Math.random() * possible.length));
#    # return text;
#    # }
#    # """
#
#    * def getDate =
#    """
#    function() {
#    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
#    var sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
#    var date = new java.util.Date();
#    return sdf.format(date);
#    }
#    """
#
#    * def SimpleDateFormatDate = getDate()
#
#    * def jsessionIDSplit =
#    """
#    function(list)
#    {
#    var session=list.split(" ", 14);
#    return session
#    }
#    """
#
#    * def sleep = function(millis){ java.lang.Thread.sleep(millis) }
#
#    * def internationalDateFormat =
#    """
#    function() {
#    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
#    var sdf = new SimpleDateFormat("yyyy-MM-dd");
#    var date = new java.util.Date();
#    return sdf.format(date);
#    }
#    """
#

#    * def futureDate =
#    """
#    function() {
#    var currentDate = new Date();
#    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat')
#    var sdf = new SimpleDateFormat("yyyy-MM-dd");
#    var futureDate = currentDate.setDate(currentDate.getDate() + 1);
#    return sdf.format(futureDate)
#    }
#    """
#
# # Random future date generation
#    * def randomFutureDate =
#    """
#    function() {
#    var today = new Date();
#    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat')
#    var sdf = new SimpleDateFormat("yyyy-MM-dd");
#    var futureDate = new Date();
#    var randomNumber = Math.floor( Math.random()*(7-1))+1
#    var futuredate=futureDate.setDate(today.getDate()+randomNumber)
#    if(futureDate.getDay() === 0 || futureDate.getDay() === 6){
#    futuredate = futureDate.setDate(futureDate.getDate()+2) }
#    return sdf.format(futuredate)
#    }
#    """
#
#    * def weekEnd =
#    """
#    function()
#    {
#    var weekend = new Date();
#    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat')
#    var sdf = new SimpleDateFormat("yyyy-MM-dd");
#    var differnece = 7-weekend.getDay();
#    result = sdf.format(weekend.setDate(weekend.getDate()+differnece))
#    return result
#    }
#    """
#
# # get the today Date in YYYY-MM-dd format
#    * def todayDate =
#    """
#    function() {
#    var currentDate = new Date();
#    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
#    var sdf = new SimpleDateFormat("yyyy-MM-dd");
#    var todayDate = currentDate.setDate(currentDate.getDate());
#    return sdf.format(todayDate)
#    }
#    """
#
# # get the Feature date by passing No of days as parameter from todate in YYYY-MM-dd format
#    * def futureDates =
#    """
#    function(s) {
#    var currentDate = new Date();
#    var SimpleDateFormat = Java.type('java.text.SimpleDateFormat');
#    var sdf = new SimpleDateFormat("yyyy-MM-dd");
#    var futureDates = currentDate.setDate(currentDate.getDate() + s);
#    return sdf.format(futureDates)
#    }
#   """
#
# # returns the Sorting order of Lists
#    * def sortOrder =
#    """
#    function(s,order) {
#    var  tmpArray = s
#    var ArrayList = Java.type('java.util.ArrayList')
#    var Collections = Java.type('java.util.Collections')
#    var list = new ArrayList()
#    karate.repeat(tmpArray.length, function(i){ list.add(tmpArray[i]) })
#    if(order == 'ASC')
#    {
#    Collections.sort(list)
#    }
#    else if(order == 'DESC')
#    {
#    Collections.sort(list,Collections.reverseOrder())
#    }
#    return list
#    }
#   """
#
#    * def getEntityId =
#    """
#    function(x,entityName)
#    {
#    var input = x.entities
#    for(var i=0;i<=input.length-1;i++)
#    {
#    if(input[i].entityType == entityName)
#    return x.entities[i].entityId
#    }
#    }
#    """
#
#    * def getEntityIdFirst =
#    """
#    function(x,entityName)
#    {
#    var input = x.entities
#    for(var i=0;i<=input.length-1;i++)
#    {
#    if(input[i].entityType == entityName)
#    return x.entities[i]
#    }
#    }
#    """
#
#    * def getEntityIdSec =
#    """
#    function(x,entityName)
#    {
#    var input = x.entities
#    for(var i=input.length-1;i>=0;i--)
#    {
#    if(input[i].entityType == entityName)
#    return x.entities[i]
#    }
#    }
#    """
#
#    * def generateString =
#    """
#    function(number){ return number + java.lang.System.currentTimeMillis() }
#    """
#
#    * def randomNumber =
#    """
#    function(number)
#    {
#    return Math.random().toString().slice(2,number+2);
#    }
#    """
#
#    * def fetchSessionID_CXP =
#    """
#    function(list)
#    {
#    var session=list.split(" ", 14);
#    return session
#    }
#    """
#
#    * def imageBase64 =
#   """
#   function(imagePath)
#   {
#   var Base64 = Java.type('java.util.Base64')
#   var encodedString = Java.type('java.lang.String')
#   return encodedString = Base64.getEncoder().encodeToString(imagePath);
#   }
#   """

  Scenario: ***** This line is required please do not delete - or the functions cannot be called *****
