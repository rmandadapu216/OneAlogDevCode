public class ContentDocumentLinkHandler {
    public static void handleAfterInsert(List<ContentDocumentLink> newList) {
        Set<Id> parentIds = new Set<Id>();
        for (ContentDocumentLink cdl : newList) {
            parentIds.add(cdl.LinkedEntityId);
        }
        List<Purchase_Contracts__c> pcRecordsToUpdate = [SELECT Id FROM Purchase_Contracts__c WHERE Id IN :parentIds];
        for (Purchase_Contracts__c co : pcRecordsToUpdate) {
            co.Signature__c = true;
        }
        if (pcRecordsToUpdate.size() > 0) {
            update pcRecordsToUpdate;
        }
        
        List<Amendment__c> amdRecordsToUpdate = [SELECT Id FROM Amendment__c WHERE Id IN :parentIds];
        for (Amendment__c co : amdRecordsToUpdate) {
            co.Signature__c = true;
        }
        if (amdRecordsToUpdate.size() > 0) {
            update amdRecordsToUpdate;
        }
    }
}