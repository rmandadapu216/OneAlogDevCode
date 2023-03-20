@isTest(SeeAllData=false)
public class inactiveVendorTest {

    static testMethod void ApprovalProcessTestMethod(){
    
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
     
     
         
     pc.Stages__c = 'Execution';
     update pc;
     system.debug(pc.Stages__c);
     
       
        
        try 
        {
            acc.Vendor_Status2__c = 'In Active';
            update acc;
        }
        catch (DmlException ex) 
        {
            System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, ex.getDmlType(0));
            System.assertEquals('Vendor cannot be inactivated if it has active purchase contracts', ex.getDmlMessage(0));
        }
   }

 
     
    
}