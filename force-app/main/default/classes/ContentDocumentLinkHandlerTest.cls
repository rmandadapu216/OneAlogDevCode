@IsTest
public class ContentDocumentLinkHandlerTest {
    @IsTest
    public static void testContentDocumentLinkHandler() {
        // Create a Purchase_Contracts__c record
        Purchase_Contracts__c pcRecord = new Purchase_Contracts__c();
        pcRecord.Name = 'Test Contract';
        pcRecord.Vendor_Name__c = '001DC00000VHUkUYAX';
        insert pcRecord;
        
        // Create an Amendment__c record
        Amendment__c amdRecord = new Amendment__c();
        amdRecord.Name = 'Test Amendment';
        amdRecord.Amendment_Type__c='Rate Change'; 
        amdRecord.Purchase_Contract__c=pcRecord.Id;
        insert amdRecord;
        
        // Create a new ContentVersion record
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Content';
        cv.PathOnClient = 'testfile.txt';
        cv.VersionData = Blob.valueOf('Test Content');
        insert cv;
        
        // Associate the ContentVersion record with the Purchase_Contracts__c record to get its ContentDocumentId
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = pcRecord.Id;
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        insert cdl;
        
        // Create a ContentDocumentLink record associated with the Purchase_Contracts__c record
        ContentDocumentLink[] existingCdl1 = [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId = :cdl.ContentDocumentId AND LinkedEntityId = :pcRecord.Id];
        if (existingCdl1.size() == 0) {
            ContentDocumentLink cdl1 = new ContentDocumentLink();
            cdl1.LinkedEntityId = pcRecord.Id;
            cdl1.ContentDocumentId = cdl.ContentDocumentId;
            insert cdl1;
        }
        
        // Create a ContentDocumentLink record associated with the Amendment__c record
        ContentDocumentLink[] existingCdl2 = [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId = :cdl.ContentDocumentId AND LinkedEntityId = :amdRecord.Id];
        if (existingCdl2.size() == 0) {
            ContentDocumentLink cdl2 = new ContentDocumentLink();
            cdl2.LinkedEntityId = amdRecord.Id;
            cdl2.ContentDocumentId = cdl.ContentDocumentId;
            insert cdl2;
        }
        
        // Verify that the Signature__c field was updated for the Purchase_Contracts__c and Amendment__c records
        pcRecord = [SELECT Signature__c FROM Purchase_Contracts__c WHERE Id = :pcRecord.Id];
        amdRecord = [SELECT Signature__c FROM Amendment__c WHERE Id = :amdRecord.Id];
        System.assertEquals(true, pcRecord.Signature__c);
        System.assertEquals(true, amdRecord.Signature__c);
    }
}