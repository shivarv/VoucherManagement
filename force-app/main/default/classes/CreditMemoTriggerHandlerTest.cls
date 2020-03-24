@isTest
private class CreditMemoTriggerHandlerTest {
    
    @testSetup
    private static void setupData() {
       Setting__c newSetting = new Setting__c(imageHardCodeUrl__c='/sfc/servlet.shepherd/version/download/');
       insert newSetting;
    }
    
    @isTest
    private static void insertTriggerTest() {
        List<Credit_Memo__c> creditMemoList = new List<Credit_Memo__c>();
        creditMemoList.add(new Credit_Memo__c(imageName__c = 'testimage1'));
        creditMemoList.add(new Credit_Memo__c(imageName__c = 'testimage2'));
        creditMemoList.add(new Credit_Memo__c(imageName__c = 'testimage3'));
        createContentVersionRecords();

        List<ContentVersion> cvs = [select id,title from ContentVersion];
        Map<String, Id> titleIdMap = new Map<String, Id>();
        titleIdMap.put(cvs.get(0).title, cvs.get(0).id);
        titleIdMap.put(cvs.get(1).title, cvs.get(1).id);

        insert creditMemoList;
        Test.startTest();
            List<Credit_Memo__c> triggerInsertRecords = [select imageName__c,imageIdHardCoded__c from Credit_Memo__c where imageName__c in ('testimage1', 'testimage2')];
            List<Credit_Memo__c> emptyInsertRecords = [select imageName__c,imageIdHardCoded__c from Credit_Memo__c where imageName__c in ('testimage3')];	
        	System.assertEquals(titleIdMap.get(triggerInsertRecords.get(0).imageName__c), triggerInsertRecords.get(0).imageIdHardCoded__c);
            System.assertEquals(titleIdMap.get(triggerInsertRecords.get(1).imageName__c), triggerInsertRecords.get(1).imageIdHardCoded__c);
            System.assertEquals(null, emptyInsertRecords.get(0).imageIdHardCoded__c);

        Test.stopTest();

        
    }
    
    @isTest
    private static void updateTriggerTest() {
        List<Credit_Memo__c> creditMemoList = new List<Credit_Memo__c>();
        creditMemoList.add(new Credit_Memo__c(imageName__c = 'wrongImage1'));
        creditMemoList.add(new Credit_Memo__c(imageName__c = 'wrongImage2'));
        createContentVersionRecords();
        List<ContentVersion> cvs = [select id,title from ContentVersion];
        Map<String, Id> titleIdMap = new Map<String, Id>();
        titleIdMap.put(cvs.get(0).title, cvs.get(0).id);
        titleIdMap.put(cvs.get(1).title, cvs.get(1).id);

        insert creditMemoList;
        Test.startTest();
            List<Credit_Memo__c> triggerUpdateRecords = [select imageName__c,imageIdHardCoded__c from Credit_Memo__c where imageName__c in ('wrongImage1', 'wrongImage2')];
            System.assertEquals(null, triggerUpdateRecords.get(0).imageIdHardCoded__c);
        	triggerUpdateRecords.get(0).imageName__c ='testimage1';
        	triggerUpdateRecords.get(1).imageName__c ='testimage2';
        	update triggerUpdateRecords;
        	triggerUpdateRecords = [select imageName__c,imageIdHardCoded__c from Credit_Memo__c where imageName__c in ('testimage1', 'testimage2')];
        	System.assertEquals(titleIdMap.get(triggerUpdateRecords.get(0).imageName__c), triggerUpdateRecords.get(0).imageIdHardCoded__c);
            System.assertEquals(titleIdMap.get(triggerUpdateRecords.get(1).imageName__c), triggerUpdateRecords.get(1).imageIdHardCoded__c);
        Test.stopTest();
    }
    
    @isTest
    private static void specialCasesTest() {
        List<Credit_Memo__c> creditMemoList = new List<Credit_Memo__c>();
        creditMemoList.add(new Credit_Memo__c(imageName__c = 'wrongImage1'));
        creditMemoList.add(new Credit_Memo__c(imageName__c = 'wrongImage2'));
        insert creditMemoList;
        
        Test.startTest();
        	List<Credit_Memo__c> triggerUpdateRecords = [select imageName__c,Amount__c, imageIdHardCoded__c from Credit_Memo__c where imageName__c in ('wrongImage1', 'wrongImage2')];
			triggerUpdateRecords.get(0).Amount__c = 500.00;
        	triggerUpdateRecords.get(1).Amount__c = 300.00;
			update triggerUpdateRecords;
        	triggerUpdateRecords = [select imageName__c,Amount__c, imageIdHardCoded__c from Credit_Memo__c where imageName__c in ('wrongImage1', 'wrongImage2')];
	        System.assertEquals(triggerUpdateRecords.get(0).imageIdHardCoded__c, null);
            System.assertEquals(triggerUpdateRecords.get(1).imageIdHardCoded__c, null);

        Test.stopTest();
    }
    
    private static void createContentVersionRecords() {
        List<ContentVersion> cvList = new List<ContentVersion>();
        cvList.add(new ContentVersion(title ='testimage1', pathonclient = 'testimage1.jpg', versionData=Blob.valueOf('/services/data/v48.0/sobjects/ContentVersion/0682w0000011eVzAAI/VersionData')));
        cvList.add(new ContentVersion(title ='testimage2', pathonclient = 'testimage2.jpg', versionData=Blob.valueOf('/services/data/v48.0/sobjects/ContentVersion/0682w0000011eVyAAI/VersionData')));
		insert cvList;        
    }

}