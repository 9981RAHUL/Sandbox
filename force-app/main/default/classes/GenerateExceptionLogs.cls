/**
* @description       : GenerateExceptionLogs
* @author            : Avinash Rajput
* @group             : 
* @last modified on  : 27-07-2023
* @last modified by  : Avinash
* Modifications Log 
**/

global class GenerateExceptionLogs {
    
    global static void insertErrorLogs(string cName, string mName, Exception ex){
    	Error_Log__c erlog = new Error_Log__c();
        erlog.Class__c = cName;
        erlog.Method__c = mName;
        if(ex != null){ 
           	erlog.Description__c  = ex.getMessage();
        	erlog.Stack_Trace__c = JSON.serialize(ex.getStackTraceString()); 
        }
        Database.insert(erlog);	 
    }
    
    public static final String New_Line_CHARACTER = '\n';
    public static final String Log_TYPE_REQUEST = 'Request';
    public static final String Log_TYPE_RESPONSE = 'Response';
    public static final Integer LOG_FIELD_SIZE_BODY;
    public static final Integer LOG_FIELD_SIZE_CLASS;
    public static final Integer LOG_FIELD_SIZE_END_P;
    public static final Integer LOG_FIELD_SIZE_HEAD_DESC;
    public static final Integer LOG_FIELD_SIZE_INT_METH;
    public static final Integer LOG_FIELD_SIZE_APEX_METH;
    public static final Integer LOG_FIELD_SIZE_OBJ;
    public static final Integer LOG_FIELD_SIZE_REC_ID;
    public static final Integer LOG_FIELD_SIZE_STATUS;
    public static final Integer LOG_FIELD_SIZE_STATUS_CODE;
    public static final Integer LOG_FIELD_SIZE_CORRELATION_ID;
    public static final Integer LOG_FIELD_SIZE_ER;
    private static final Set<String> HEADERS_TO_LOG; 
	
    static {
        LOG_FIELD_SIZE_BODY = Integration_Log__c.Body__c.getDescribe().getLength();
        LOG_FIELD_SIZE_CLASS = Integration_Log__c.Class_Name__c.getDescribe().getLength();
        LOG_FIELD_SIZE_END_P = Integration_Log__c.Endpoint__c.getDescribe().getLength();
        LOG_FIELD_SIZE_HEAD_DESC = Integration_Log__c.Integration_Header__c.getDescribe().getLength();
        LOG_FIELD_SIZE_INT_METH = Integration_Log__c.Method__c.getDescribe().getLength();
        LOG_FIELD_SIZE_APEX_METH = Integration_Log__c.Method_Name__c.getDescribe().getLength();
        LOG_FIELD_SIZE_OBJ = Integration_Log__c.Object_Type__c.getDescribe().getLength();
        LOG_FIELD_SIZE_REC_ID = Integration_Log__c.Record_ID__c.getDescribe().getLength();
        LOG_FIELD_SIZE_STATUS = Integration_Log__c.Status__c.getDescribe().getLength();
        LOG_FIELD_SIZE_STATUS_CODE = Integration_Log__c.Status__c.getDescribe().getLength();
        //LOG_FIELD_SIZE_CORRELATION_ID = Integration_Log__c.Correlation_ID__c.getDescribe().getLength();
        LOG_FIELD_SIZE_ER = Integration_Log__c.Error__c.getDescribe().getLength();
        HEADERS_TO_LOG = new set<string>();
        //query on headers_to_log__mdt and add label to the set
        for(Headers_To_Log__mdt mdt : [Select label from Headers_To_Log__mdt]){
            HEADERS_TO_LOG.add(mdt.label);
        }
    }
 
    
    
    //Integration log record for the service error handling
    public static void insertIntegrationLog(
    	HttpRequest req,
        HttpResponse resp,
        Map<String, String> logAttributeMap,
        DateTime reqSentTime,
        DateTime resRecvTime
    ){
    	List<Integration_Log__c> logs = new List<Integration_Log__c>();
        String headers = createHeaderDescription(resp);
        logs.add(
            new Integration_Log__c(
                Request_Sent_Time__c = reqSentTime,
                Response_Received_Time__c = resRecvTime,
                Endpoint__c = getValueToStore(req.getEndpoint(), LOG_FIELD_SIZE_END_P),
                Method__c = getValueToStore(req.getMethod(), LOG_FIELD_SIZE_INT_METH),
                Body__c = getValueToStore(resp.getBody(), LOG_FIELD_SIZE_BODY),
                Status__c = getValueToStore(resp.getStatus(), LOG_FIELD_SIZE_STATUS),
                Status_Code__c = getValueToStore(String.valueOf(resp.getStatusCode()),LOG_FIELD_SIZE_STATUS_CODE),
                Integration_Header__c = getValueToStore(headers, LOG_FIELD_SIZE_HEAD_DESC),
                Class_Name__c = getValueToStore(logAttributeMap.get('className'), LOG_FIELD_SIZE_CLASS),
                Method_Name__c = getValueToStore(logAttributeMap.get('methodName'), LOG_FIELD_SIZE_APEX_METH),
                Object_Type__c = getValueToStore(logAttributeMap.get('objectType'), LOG_FIELD_SIZE_OBJ),
                Record_ID__c = getValueToStore(logAttributeMap.get('recordId'), LOG_FIELD_SIZE_REC_ID),
                Error__c = getValueToStore(logAttributeMap.get('error'), LOG_FIELD_SIZE_ER),
               /* Correlation_ID__c = logAttributeMap.containsKey('correlationId')
                	?getValueToStore(logAttributeMap.get('correlationId'), LOG_FIELD_SIZE_CORRELATION_ID)
                    :'',*/
                Type__c = Log_TYPE_RESPONSE
                                                    
            )
        );
        saveLog(logs);
    }
    
    /*
    Iterate all over possible header key/values in request and add time to a consolidated string if they exist
    @param HttpRequest req             					The HttpRequest instance to log the header for 
    @return String									  	The String of the headers formatted for logging.
    */
    
    public static void insertIntegrationLog(HttpRequest req, Map<String, String> logAttributeMap, DateTime reqSentTime){
        List<Integration_Log__c> logs = new List<Integration_Log__c>();
        String headers = createHeaderDescription(req);
        logs.add(
        new Integration_Log__c(
        	Request_Sent_Time__c = reqSentTime,
            Body__c = getValueToStore(req.getBody(), LOG_FIELD_SIZE_BODY),
            Method__c = getValueToStore(req.getMethod(), LOG_FIELD_SIZE_INT_METH),
            Class_Name__c = getValueToStore(logAttributeMap.get('className'), LOG_FIELD_SIZE_CLASS),
            Method_Name__c = getValueToStore(logAttributeMap.get('methodName'), LOG_FIELD_SIZE_APEX_METH),
            Endpoint__c = getValueToStore(req.getEndpoint(), LOG_FIELD_SIZE_END_P),
            Integration_Header__c = getValueToStore(headers, LOG_FIELD_SIZE_HEAD_DESC),
            Correlation_ID__c = logAttributeMap.containsKey('correlationId')
            	?getValueToStore(logAttributeMap.get('correlationId'), LOG_FIELD_SIZE_CORRELATION_ID)
            	:'',
            Type__c = Log_TYPE_REQUEST  
        )
        );
    	saveLog(logs);
    }
    
    private static string createHeaderDescription(HttpRequest req){
        String headerDesc = '';
        for(String key : HEADERS_TO_LOG){
            if(req.getHeader(key) != null){
                headerDesc += createHeaderDescription(key, req.getHeader(key));
                System.debug('HeaderRequest is'+ headerDesc);
            }
        }
        System.debug('HeaderRequest is'+ headerDesc);
        return headerDesc;
    }
    
    private static String createHeaderDescription(HttpResponse res){
        String headerDesc = '';
        for(String key : res.getHeaderKeys()){
            headerDesc += createHeaderDescription(key, res.getHeader(key));
            System.debug('HeaderResponse is'+ headerDesc);
        }
        System.debug('HeaderResponse is'+ headerDesc);
    	return headerDesc;
    }
    
    private static String createHeaderDescription(String key, String value){
        return key + ' : ' + value + NEW_LINE_CHARACTER;
    }
    
    
    public static String getValueToStore(String val, Integer fldSize){
        String retStr = '';
        if(String.isNotBlank(val)){
            retStr = val.length() > fldSize ? val.left(fldSize) : val;
        }
    	return retStr;
    }
    
    private static void saveLog(List<Integration_Log__c> logsToSave){
        Database.insert(logsToSave, false);
    }

}