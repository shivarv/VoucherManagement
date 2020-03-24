@isTest
private class DownloadPdfControllerTest {

    @testSetup
    private static void setupData() {
       Setting__c newSetting = new Setting__c(imageHardCodeUrl__c='/sfc/servlet.shepherd/version/download/');
       insert newSetting;
       createData();
    }
    
    @isTest
    private static void testNoRecord() {
        PageReference pageRef = Page.downloadPdf;
    	Test.setCurrentPage(pageRef);     
	    downloadPdfController pdfController  = new downloadPdfController();
        System.assert(pdfController.credit == null);
    }
    
    @isTest
    private static void testPositive() {
        PageReference pageRef = Page.downloadPdf;
    	Test.setCurrentPage(pageRef);     
        Credit_Memo__c newCreditMemo = new Credit_Memo__c(imageName__c = 'testimage');
        insert newCreditMemo;
       	ApexPages.currentPage().getParameters().put('id',newCreditMemo.id);
		ApexPages.StandardController stdMemoController = new ApexPages.StandardController(newCreditMemo);
	    downloadPdfController pdfController  = new downloadPdfController(stdMemoController);
        ContentVersion cv = [select id from contentversion where title = 'testimage' limit 1];
        System.assertEquals(Setting__c.getOrgDefaults().imageHardCodeUrl__c+ cv.id, pdfController.imageUrl);
    }
    
    private static void createData() {
        ContentVersion cv = new ContentVersion(title ='testimage', pathonclient = 'goldbackground.jpg', versionData=Blob.valueOf('/services/data/v48.0/sobjects/ContentVersion/0682w0000011eVzAAI/VersionData'));
        insert cv;
    }
}