@isTest
private class ImageControllerTest {
    static testMethod void testImageController() {
        // Create a test Purchase_contracts__c record
        Purchase_contracts__c pc = new Purchase_contracts__c();
        pc.Name = 'Test Contract';
        pc.Vendor_Name__c ='001DC00000VHUkUYAX';
        insert pc;

        // Create a test ContentVersion record
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Image';
        cv.PathOnClient = 'test.png'; // set a valid file path
        cv.VersionData = Blob.valueOf('Test Image Data');
        insert cv;

        // Get the related ContentDocument record
        ContentDocument cd = [SELECT Id, Title FROM ContentDocument WHERE Id = :cv.ContentDocumentId];

        // Create a test ContentDocumentLink record
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cd.Id;
        cdl.LinkedEntityId = pc.Id;
        cdl.ShareType = 'V';
        insert cdl;

        // Instantiate the ImageController with the test Purchase_contracts__c record
        ApexPages.StandardController sc = new ApexPages.StandardController(pc);
        ImageController ic = new ImageController(sc);

        // Verify that the imageURL property was set correctly
        System.assertNotEquals(null, ic.imageURL);
    }
}