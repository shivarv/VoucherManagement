public class NewMemoController {

    @AuraEnabled
    public static Setting__c getDefaultSetting() {
        return Setting__c.getOrgDefaults();
    }
}