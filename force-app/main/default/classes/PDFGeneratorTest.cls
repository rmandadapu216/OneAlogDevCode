@isTest
private class PDFGeneratorTest {

    @isTest
    static void testGeneratePDF() {
        // Create a test Account record
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;

        // Create a test Contract record
        Contract c = new Contract();
        c.Name = 'Test Contract';
        c.StartDate = Date.today();
        c.ContractTerm = 12;
        c.OwnerId = UserInfo.getUserId();
        c.AccountId = a.Id;
        insert c;

        // Call generatePDF method
        Test.startTest();
        PageReference pdf = Page.contractpdf;
        pdf.getParameters().put('id', c.Id);
        pdf.setRedirect(true);
        Blob pdfBlob = pdf.getContent();
        PDFGenerator.generatePDF(c.Id);
        Test.stopTest();

        // Verify that an Attachment record was created
        List<Attachment> attachments = [SELECT Id FROM Attachment WHERE ParentId = :c.Id];
        System.assertEquals(1, attachments.size());
        Attachment attachment = attachments[0];

        // Verify that the attachment contains the expected PDF file
        System.assertNotEquals(null, attachment.Body);
        System.assertEquals('YourPDFName.pdf', attachment.Name);
    }
}