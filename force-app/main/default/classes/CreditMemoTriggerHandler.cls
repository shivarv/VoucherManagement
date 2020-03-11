public class CreditMemoTriggerHandler {

    public static List<Credit_Memo__c> getRecordsToUpdate(List<Credit_Memo__c> records, Map<Id, Credit_Memo__c> oldMap, Map<Id, Credit_Memo__c> newMap, Boolean isInsert) {
		List<Credit_Memo__c> recordsToUpdate = new List<Credit_Memo__c>();
		for(Credit_Memo__c rec : records) {
            if(String.isBlank(rec.imageName__c)) {
                continue;
            }
       		if((isInsert == true) || ( isInsert == false &&
            			!String.isBlank(rec.imageName__c) && oldMap.get(rec.Id).imageName__c != newMap.get(rec.Id).imageName__c)
            ) {
                recordsToUpdate.add(rec);
            }
        }
        return recordsToUpdate;
    }
    
    public static void updateWithImageFileId(List<Credit_Memo__c> recordsToUpdate) {
        List<ContentVersion> contentVersions = [select id, title,IsLatest from contentVersion where title in : getNamesFromList(recordsToUpdate) and IsLatest = true];
        Map<String, Id> contentVersionMap = getMapOfNameAndId(contentVersions);
        System.debug('contentMap '+contentVersionMap);
        if(contentVersionMap.isEmpty()) {
            return;
        }
        for(Credit_Memo__c cm : recordsToUpdate) {
                    System.debug('cm '+cm.imageName__c+ '  '+contentVersionMap.containsKey(cm.imageName__c));
            if(String.isBlank(cm.imageName__c) || contentVersionMap.containsKey(cm.imageName__c) == false) {
                continue;
            }
            cm.imageIdHardCoded__c = contentVersionMap.get(cm.imageName__c);
        }
    }
    private static Map<String, Id> getMapOfNameAndId(List<ContentVersion> contentVersions) {
    	Map<String, Id> newContentVersionMap = new Map<String, Id>();
        if(contentVersions.isEmpty()) {
            return newContentVersionMap;
        }
        for(ContentVersion conVer : contentVersions) {
            newContentVersionMap.put(conVer.title, conVer.Id);
        }
        return newContentVersionMap;
    }
    
    private static List<String> getNamesFromList(List<Credit_Memo__c> records) {
        Set<String> titleNamesSet = new Set<String>();
        List<String> titleNamesList = new List<String>();
        if(records.isEmpty()) {
            return titleNamesList;
        }
        for(Credit_Memo__c cm : records) {
            if(String.isBlank(cm.imageName__c)) {
                continue;
            }
            titleNamesSet.add(cm.imageName__c);
        }
        if(!titleNamesSet.isEmpty()) {
        	titleNamesList.addAll(titleNamesSet);
        }
        return titleNamesList;
    }

}