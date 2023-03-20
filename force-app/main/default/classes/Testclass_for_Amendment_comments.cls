@istest
public class Testclass_for_Amendment_comments {

    static testmethod void amendmentcomments(){
        //create a record 
     
        account ac=new account ();
        ac.Name='amnd Test Method 1';
        ac.Vendor_Status2__c='Active';
         insert ac;
        
        Purchase_Contracts__c pcs = new Purchase_Contracts__c();
                pcs.name = 'ContractTest1';
                pcs.Vendor_Name__c = ac.id;
                pcs.Stages__c = 'Initiation';
                pcs.Contract_type__c='Software';
                pcs.Contract_Term__c = 5;
                pcs.Approval_Date__c=system.today();
                pcs.Execution_Date__c=system.today()+5;
                pcs.Signature__c=true;
                insert pcs;
        Contract_Material__c  cm1=new Contract_Material__c ();
        cm1.Purchase_Contract__c=pcs.ID;
        cm1.Name='Contractmat1';
        cm1.Quantiy__c=20;
        cm1.Unit_Price__c=100;
        cm1.Unit_Of_Measurement__c='Each';
        insert cm1;
        pcs.Stages__c='Negotiation';
        update pcs;
        pcs.Delivery_Schedule__c='Weekly';
        pcs.Stages__c='Generation';
        update pcs;
      pcs.Stages__c='Pending Approval';
        user usr1 =[select id from user where alias='Nr'];
        
         // Create an approval request for the account
      approval.ProcessSubmitRequest appsub =new approval.ProcessSubmitRequest();
        appsub.setComments('Submitting request for approval');
        appsub.setObjectId(pcs.Id);
        
         // Submit on behalf of a specific submitter
         appsub.setSubmitterId(usr1.Id);
        
         // Submit the record to specific process and skip the criteria evaluation
         appsub.setProcessDefinitionNameOrId('Approval_for_Purchase_Contract4');
        appsub.setSkipEntryCriteria(true);
        
        // Submit the approval request for the account
        approval.ProcessResult result =approval.Process(appsub);
        
          // Verify the result
         system.Assert(result.isSuccess());
        system.assertEquals('Pending',result.getInstanceStatus(),'Instance Status'+result.getInstanceStatus());
     
        // Approve the submitted request
        // First, get the ID of the newly created item

        Approval.ProcessWorkItemRequest req1;
         	List<Id> newWorkItemIds = result.getNewWorkItemIds(); 
         for(integer i=0;i<4; i++){
             //Approve the submitted request.  
             //First, get the ID of the newly created item
              newWorkItemIds = result.getNewWorkItemIds();    	
             //Instantiate the new ProcessWorkItemRequest object and populate it
             req1 = new Approval.ProcessWorkItemRequest();
             req1.setComments('Approving request.');
             req1.setAction('Approve');
             req1.setNextApproverIds(new Id[] {UserInfo.getUserId()});    	
             //Use the ID from the newly created item to specify the item to be worked
             req1.setWorkItemId(newWorkItemIds.get(0));
             result = Approval.process(req1);
            
         }
        
              System.assert(result.isSuccess(), 'Result Status:'+result.isSuccess());
        
        System.assertEquals(
            'Approved', result.getInstanceStatus(), 
            'Instance Status'+result.getInstanceStatus());
         pcs =[select id, name ,Stages__c from Purchase_Contracts__c where name='ContractTest1' ];
        system.debug('Latest stage = ' + pcs.stages__c);
       pcs.Stages__c = 'Execution';
     update pcs;
     system.debug(pcs.Stages__c);
        Amendment__c amd =new Amendment__c ();
        amd.Amendment_Type__c='Rate Change';
        amd.Name=pcs.Name;
        
    }
}