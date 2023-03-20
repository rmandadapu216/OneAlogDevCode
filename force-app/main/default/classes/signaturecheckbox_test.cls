@IsTest
public class signaturecheckbox_test {
    
    
    static testmethod void testmethod1(){
        
            
    Test.startTest();
    Account acc = new Account();
    acc.Record_Type__c = 'Vendor';
    acc.name = 'Test Vendor';
    acc.Vendor_Status2__c = 'Active';
    insert acc;
    
    Purchase_Contracts__c pc = new Purchase_Contracts__c();
    pc.name = 'Purchase Contracts1';
    pc.Vendor_Name__c = acc.id;
    pc.Contract_type__c = 'Software';   
    pc.Stages__c = 'Initiation';
    pc.Contract_Term__c = 2;
    pc.Delivery_Schedule__c = 'Weekly';
    pc.Terms_and_Conditions__c = 'www.salesforce.com';
    pc.Approval_Date__c = system.today();
    pc.Execution_Date__c = system.today() + 7;
    pc.Signature__c = True;
    insert pc;
      
    Contract_Material__c cm = new Contract_Material__c();    
    cm.Name = 'Contract Material';
    cm.Unit_Price__c = 100;
    cm.Quantiy__c = 2;
    cm.Unit_Of_Measurement__c = 'Gallons';
    cm.Purchase_Contract__c = pc.id; 
    insert cm;  
        
    pc.Stages__c = 'Negotiation';
    Update pc;
    
    pc.Stages__c = 'Generation';
    Update pc;
     
    pc.Stages__c = 'Pending Approval';
     
    List<User> lstUser = [select Id from User where IsActive = True limit 1];
     
     //Create an approval request for the change
     Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
     req1.setComments('Submitting request for approval.');
     req1.setObjectId(pc.Id);
     req1.setNextApproverIds(new Id[] {UserInfo.getUserId()});
     
     //Submit the approval request for the change
     Approval.ProcessResult result = Approval.process(req1);
     
     //Verify the result
     System.assert(result.isSuccess());
     
     System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status'+result.getInstanceStatus());
     system.debug(pc.Stages__c);	
     
     
     
     Approval.ProcessWorkItemRequest req3;
     
     for(integer i=0;i<4; i++){
         //Approve the submitted request.  
         //First, get the ID of the newly created item
         List<Id> newWorkItemIds = result.getNewWorkItemIds();    	
         //Instantiate the new ProcessWorkItemRequest object and populate it
         req3 = new Approval.ProcessWorkItemRequest();
         req3.setComments('Approving request.');
         req3.setAction('Approve');
         req3.setNextApproverIds(new Id[] {UserInfo.getUserId()});    	
         //Use the ID from the newly created item to specify the item to be worked
         req3.setWorkItemId(newWorkItemIds.get(0));
         result = Approval.process(req3);
         
     }
     pc = [select id, stages__c from Purchase_Contracts__c where name = 'Purchase Contracts1'];
     system.debug('Latest stage - ' + pc.stages__c);
     
      ContentVersion content1=new ContentVersion(); 
        content1.Title='Header_Picture1'; 
        content1.PathOnClient='/' + content1.Title + '.jpg'; 
        Blob bodyBlob1=Blob.valueOf('Unit Test ContentVersion Body'); 
        content1.VersionData=bodyBlob1; 
        //content.LinkedEntityId=sub.id;
        content1.origin = 'H';
        insert content1;
        ContentDocumentLink contentlink1=new ContentDocumentLink();
        contentlink1.LinkedEntityId=pc.id;
        contentlink1.contentdocumentid=[select contentdocumentid from contentversion where id =: content1.id].contentdocumentid;
        contentlink1.ShareType = 'I';
        contentlink1.Visibility = 'AllUsers'; 
        
        
        insert contentlink1;
        
         
     pc.Stages__c = 'Execution';
       
     update pc;
     system.debug(pc.Stages__c);
        
    Amendment__c amd = new Amendment__c();
    amd.Amendment_Type__c = 'Rate Change';
    amd.name = 'Purchase Contract1 Amend1';  
    amd.Purchase_Contract__c = pc.id; 
        
    insert amd;  
        
        
     amd.Stage__c = 'Pending Approval';
         
      lstUser = [select Id from User where IsActive = True limit 1];
     
       
     //Create an approval request for the change
     Approval.ProcessSubmitRequest req10 = new Approval.ProcessSubmitRequest();
     req10.setComments('Submitting request for approval.');
     req10.setObjectId(amd.Id);
     req10.setNextApproverIds(new Id[] {UserInfo.getUserId()});
     
     //Submit the approval request for the change
     result = Approval.process(req10);
     
     //Verify the result
     System.assert(result.isSuccess());
     
     System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status'+result.getInstanceStatus());
     system.debug(amd.Stage__c);	
     amd = [select id, Stage__c from Amendment__c where name = 'Purchase Contract1 Amend1'];
     system.debug('Amend Pending Approval stage - ' + amd.Stage__c);
     
    Approval.ProcessWorkItemRequest req11;
     
     for(integer i=0;i<1; i++){
         //Approve the submitted request.  
         //First, get the ID of the newly created item
         List<Id> newWorkItemIds = result.getNewWorkItemIds();    	
         //Instantiate the new ProcessWorkItemRequest object and populate it
         req11 = new Approval.ProcessWorkItemRequest();
         req11.setComments('Approving request.');
         req11.setAction('Approve');
         req11.setNextApproverIds(new Id[] {UserInfo.getUserId()});    	
         //Use the ID from the newly created item to specify the item to be worked
         req11.setWorkItemId(newWorkItemIds.get(0));
         result = Approval.process(req11);
         
     }
     
	
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        //content.LinkedEntityId=sub.id;
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=amd.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        
     amd.Signature__c = True;
     update amd; 
        
     amd = [select id, Signature__c from Amendment__c where name = 'Purchase Contract1 Amend1'];
     system.debug('Amend Approval stage - ' + amd.Signature__c);
     
	
      
       
        
        Test.stopTest();
        
    }
}