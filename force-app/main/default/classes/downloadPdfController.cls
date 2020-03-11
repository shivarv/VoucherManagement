public class downloadPdfController {
    Id memoId;
    public String imageUrl{get;set;}
    public Credit_Memo__c credit{get;set;}
    public List<String> notes {get;set;}
    public downloadPdfController() {
        setDatas();
    }
    
    public downloadPdfController(ApexPages.StandardController sc) {
        setDatas();
    }
    
    private void setDatas() {
        Id recordId =  Apexpages.currentPage().getParameters().get('id') != null ? Apexpages.currentPage().getParameters().get('id') : 'a002w000003FRgj';
        List<Credit_Memo__c> creditRecordList = [select id, Account__r.name,name, Credit_Expiry_Date__c,
                                       Credit_Memo_Date__c, Exchange_Rate__c,note__c, Amount__c, imageName__c from Credit_Memo__c where id = :recordId limit 1]; 
        if(creditRecordList.isEmpty()) {
            return;
        }
        credit = creditRecordList.get(0);
        System.debug('credit url '+ credit);
        
		notes =	!String.isBlank(credit.note__c) ? credit.note__c.split('\n') : new List<String>();
        List<contentversion> cv = [select id,contentdocumentid , title from contentversion where title = :credit.imageName__c and islatest = true limit 1];
        imageUrl = Setting__c.getOrgDefaults().imageHardCodeUrl__c + cv.get(0).id;
        System.debug('image url '+ imageUrl);
    }
}