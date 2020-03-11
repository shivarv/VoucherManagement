trigger CreditMemoTrigger on Credit_Memo__c (before insert, before update) {
    
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) {
    	List<Credit_Memo__c> records = CreditMemoTriggerHandler.getRecordsToUpdate(Trigger.new, Trigger.oldMap, Trigger.newMap, Trigger.isInsert);
    	System.debug('records '+records);
        if(records.isEmpty()) {
        	return; 
        }
        CreditMemoTriggerHandler.updateWithImageFileId(records);
    }

}