@isTest
public class saveVfPDFCtrl2AmenTest {

    @isTest
    static void testPdfAction() {
        // Create test Amendment__c record
        Amendment__c amendment = new Amendment__c();
        amendment.Name = 'Test Amendment';
        amendment.Amendment_Type__c = 'Rate Change'; 
        amendment.Purchase_Contract__c = 'a01DC000003WVtCYAW';
        insert amendment;

        // Set up page parameters
        ApexPages.currentPage().getParameters().put('id', amendment.Id);

        // Call pdfAction method
        saveVfPDFCtrl2Amen controller = new saveVfPDFCtrl2Amen(new ApexPages.StandardController(amendment));
        PageReference pdfPage = controller.pdfAction();

        // Verify that a ContentVersion record was created
        List<ContentVersion> contentVersions = [SELECT Id, Title FROM ContentVersion WHERE Title = 'Amendment1'];
        System.assertEquals(1, contentVersions.size());
        System.assertEquals('Amendment1', contentVersions[0].Title);

        // Verify that a ContentDocumentLink record was created
        List<ContentDocumentLink> contentDocLinks = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :amendment.Id];
        System.assertEquals(1, contentDocLinks.size());

        // Verify that the PageReference is redirected to the expected page
        System.assertEquals(true, pdfPage.getRedirect());
        String url = pdfPage.getUrl();
        String pageName = url.substringAfterLast('/');
        System.assertEquals('Amendementpdf', pageName);
        System.assertEquals(amendment.Id, pdfPage.getParameters().get('id'));
    }
}