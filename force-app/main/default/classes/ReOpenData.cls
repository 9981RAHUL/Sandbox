public class ReOpenData {
    
    public static void NewReOpenDataMethod(Id caseId){
      
        
        set<String> setId = new set <String>();
      
        list<BucketData__c> updatebucketLst = new list<BucketData__c>();
        list<BucketData__c> bucketLst = new list<BucketData__c>();
        
        list <Case> csLst = [select Id,Bucket__c,Case_Re_Open_Resolution_Reason__c,Reopen_Count_New__c from Case where Id=:caseId limit 1];
        System.debug('===csLst==='+csLst);
        
        list<BucketData__c> bucketIdLst = [select Id,CaseId__c,Re_Open_Resolution_Reason1__c,Re_Open_Resolution_Reason2__c	,Re_Open_Resolution_reason3__c from BucketData__c where CaseId__c =: csLst];
       	System.debug('===Bucket Id List is===' + bucketIdLst);
        
        if(bucketIdLst !=null){
            for(Case cs :csLst){
                if (cs.Bucket__c =='Re Open' && cs.Case_Re_Open_Resolution_Reason__c != null && cs.Reopen_Count_New__c ==1)
                {
                    
                    BucketData__c bucketData = new BucketData__c();
                    
                    bucketData.CaseId__c =cs.Id;
                    System.debug('===Case Id Of Bucket Object===' + bucketData.CaseId__c);
                    
                    bucketData.Re_Open_Resolution_Reason1__c =cs.Case_Re_Open_Resolution_Reason__c;
                    System.debug('===Re Open Resolution Reason1===' + bucketData.Re_Open_Resolution_Reason1__c);
               
                    bucketData.total_ReOpen__c =cs.Reopen_Count_New__c;
                 	System.debug('===Total ReOpen1===' + bucketData.total_ReOpen__c);
                  
                    if(bucketData.total_ReOpen__c ==1)
                    {
                       
                        bucketLst.add(bucketData);
                      
                    }
                } 
                else if  (cs.Bucket__c =='Re Open' && cs.Case_Re_Open_Resolution_Reason__c != null && cs.Reopen_Count_New__c ==2){
                    for(BucketData__c bucketUpdateData :bucketIdLst){
                        
                        if(bucketUpdateData.Re_Open_Resolution_Reason1__c !=Null && bucketUpdateData.Re_Open_Resolution_Reason2__c	 ==Null && cs.Bucket__c =='Re Open' && cs.Reopen_Count_New__c ==2)
                        {
                            bucketUpdateData.Re_Open_Resolution_Reason2__c	 =cs.Case_Re_Open_Resolution_Reason__c;
                           	System.debug('===Re Open Resolution Reason2===' + bucketUpdateData.Re_Open_Resolution_Reason2__c);
                            
                            bucketUpdateData.total_ReOpen__c = cs.Reopen_Count_New__c; 
                       		System.debug('===Total ReOpen2===' + bucketUpdateData.total_ReOpen__c);
                            
                            if(bucketUpdateData.total_ReOpen__c !=1 && bucketUpdateData.total_ReOpen__c !=3){
                                updatebucketLst.add(bucketUpdateData);
                            
                                
                            }
                        }
                    }
                }
                
                
                else if  (cs.Bucket__c =='Re Open' && cs.Case_Re_Open_Resolution_Reason__c != null && cs.Reopen_Count_New__c ==3){
                    {
                        for(BucketData__c bucketUpdateData :bucketIdLst){
                            
                            if(bucketUpdateData.Re_Open_Resolution_Reason1__c !=Null && bucketUpdateData.Re_Open_Resolution_Reason2__c	 !=Null && cs.Bucket__c =='Re Open' && cs.Reopen_Count_New__c ==3)
                            {
                                bucketUpdateData.Re_Open_Resolution_reason3__c =cs.Case_Re_Open_Resolution_Reason__c;
                                System.debug('===Re Open Resolution Reason2===' + bucketUpdateData.Re_Open_Resolution_reason3__c);                              
                                
                                bucketUpdateData.total_ReOpen__c = cs.Reopen_Count_New__c;
                                System.debug('===Total ReOpen3===' + bucketUpdateData.total_ReOpen__c);
                            
                                
                                if(bucketUpdateData.total_ReOpen__c !=1 && bucketUpdateData.total_ReOpen__c !=2){
                                    updatebucketLst.add(bucketUpdateData);
                               
                                    
                                }
                            }
                        }
                        
                    }
                }
                
            }
        }
        insert bucketLst;
        update updatebucketLst;
        update csLst;
        
   
        
        
    }
}