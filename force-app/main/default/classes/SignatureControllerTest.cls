@isTest
private class SignatureControllerTest {

    static testMethod void testSaveSignature() {
        
        // Create a test Purchase_Contracts__c record
        Purchase_Contracts__c testContract = new Purchase_Contracts__c();
        testContract.Name = 'Test Contract';
        testContract.Vendor_Name__c = '001DC00000VHUkUYAX';
        insert testContract;
        
        // Create a mock signature image
        String mockSignature = 'iVBORw0KGgoAAAANSUhEUgAAAlgAAADICAYAAACV5Z5jAAAAAXNSR0IArs4c6QAA';
        
        // Call the saveSignature method with the test data
        Test.startTest();
        SignatureController.saveSignature(mockSignature, testContract.Id);
        Test.stopTest();
        
        // Verify that a ContentVersion and ContentDocumentLink were created
        ContentVersion[] contentVersions = [SELECT Id FROM ContentVersion];
        System.assertEquals(1, contentVersions.size(), 'ContentVersion not created');
        
        ContentDocumentLink[] contentDocumentLinks = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :testContract.Id];
System.assertEquals(1, contentDocumentLinks.size(), 'ContentDocumentLink not created');

    }
}