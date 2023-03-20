@istest
public class Testclass_for_purchase_contract_comments {

    static testMethod void method1(){
        //create a record 
     
        account ac=new account ();
        ac.Name='Cont Test Method 1';
        ac.Vendor_Status2__c='Active';
         insert ac;
        
        Purchase_Contracts__c pcs1 = new Purchase_Contracts__c();
                pcs1.name = 'ContTest1';
                pcs1.Vendor_Name__c = ac.id;
                pcs1.Stages__c = 'Initiation';
                pcs1.Contract_type__c='Software';
                pcs1.Contract_Term__c = 5;
                insert pcs1;
        Contract_Material__c  cm1=new Contract_Material__c ();
        cm1.Purchase_Contract__c=pcs1.ID;
        cm1.Name='Contmat1';
        cm1.Quantiy__c=20;
        cm1.Unit_Price__c=100;
        cm1.Unit_Of_Measurement__c='Each';
        insert cm1;
        pcs1.Stages__c='Negotiation';
        update pcs1;
        pcs1.Delivery_Schedule__c='Weekly';
        pcs1.Stages__c='Generation';
        update pcs1;
      pcs1.Stages__c='Pending Approval';
        user usr1 =[select id from user where alias='Nr'];
        
         // Create an approval request for the account
      approval.ProcessSubmitRequest appsub1 =new approval.ProcessSubmitRequest();
        appsub1.setComments('Submitting request for approval');
        appsub1.setObjectId(pcs1.Id);
        
         // Submit on behalf of a specific submitter
         appsub1.setSubmitterId(usr1.Id);
        
         // Submit the record to specific process and skip the criteria evaluation
         appsub1.setProcessDefinitionNameOrId('Approval_for_Purchase_Contract4');
        appsub1.setSkipEntryCriteria(true);
        
        // Submit the approval request for the account
        approval.ProcessResult result1 =approval.Process(appsub1);
        
          // Verify the result
         system.Assert(result1.isSuccess());
        system.assertEquals('Pending',result1.getInstanceStatus(),'Instance Status'+result1.getInstanceStatus());
        

        Approval.ProcessWorkItemRequest req1;
         	List<Id> newWorkItemIds = result1.getNewWorkItemIds(); 
         for(integer i=0;i<3; i++){
             //Approve the submitted request.  
             //First, get the ID of the newly created item
              newWorkItemIds = result1.getNewWorkItemIds();    	
             //Instantiate the new ProcessWorkItemRequest object and populate it
             req1 = new Approval.ProcessWorkItemRequest();
             req1.setComments('Approving request.');
             req1.setAction('Approve');
             req1.setNextApproverIds(new Id[] {UserInfo.getUserId()});    	
             //Use the ID from the newly created item to specify the item to be worked
             req1.setWorkItemId(newWorkItemIds.get(0));
             result1 = Approval.process(req1);
            
         }
         newWorkItemIds = result1.getNewWorkItemIds();    	
             //Instantiate the new ProcessWorkItemRequest object and populate it
             req1 = new Approval.ProcessWorkItemRequest();
             req1.setComments('Rejecting request.');
             req1.setAction('Reject');
             req1.setNextApproverIds(new Id[] {UserInfo.getUserId()});    	
             //Use the ID from the newly created item to specify the item to be worked
             req1.setWorkItemId(newWorkItemIds.get(0));
             result1 = Approval.process(req1);
              System.assert(result1.isSuccess(), 'Result Status:'+result1.isSuccess());
        
        System.assertEquals(
            'Rejected', result1.getInstanceStatus(), 
            'Instance Status'+result1.getInstanceStatus());
        pcs1.Reason_of_Rejection__c=req1.getComments();
        system.debug(pcs1.Reason_of_Rejection__c);
        pcs1=[select id , name,Stages__c from Purchase_Contracts__c where name='ContTest1' ];
         system.debug(pcs1.Stages__c);
    }
        
        static testMethod void method2(){
        //create a record 
     
        account ac=new account ();
        ac.Name='Cont Test Method 2';
        ac.Vendor_Status2__c='Active';
         insert ac;
        
        Purchase_Contracts__c pcs2 = new Purchase_Contracts__c();
                pcs2.name = 'ContTest2';
                pcs2.Vendor_Name__c = ac.id;
                pcs2.Stages__c = 'Initiation';
                pcs2.Contract_type__c='Software';
                pcs2.Contract_Term__c = 5;
                insert pcs2;
        Contract_Material__c  cm2=new Contract_Material__c ();
        cm2.Purchase_Contract__c=pcs2.ID;
        cm2.Name='Contmat2';
        cm2.Quantiy__c=20;
        cm2.Unit_Price__c=100;
        cm2.Unit_Of_Measurement__c='Each';
        insert cm2;
        pcs2.Stages__c='Negotiation';
        update pcs2;
        pcs2.Delivery_Schedule__c='Weekly';
        pcs2.Stages__c='Generation';
        update pcs2;
      pcs2.Stages__c='Pending Approval';
        user usr1 =[select id from user where alias='Nr'];
        
         // Create an approval request for the account
      approval.ProcessSubmitRequest appsub2 =new approval.ProcessSubmitRequest();
        appsub2.setComments('Submitting request for approval');
        appsub2.setObjectId(pcs2.Id);
        
         // Submit on behalf of a specific submitter
         appsub2.setSubmitterId(usr1.Id);
        
         // Submit the record to specific process and skip the criteria evaluation
         appsub2.setProcessDefinitionNameOrId('Approval_for_Purchase_Contract4');
        appsub2.setSkipEntryCriteria(true);
        
        // Submit the approval request for the account
        approval.ProcessResult result2 =approval.Process(appsub2);
        
          // Verify the result
         system.Assert(result2.isSuccess());
        system.assertEquals('Pending',result2.getInstanceStatus(),'Instance Status'+result2.getInstanceStatus());
        
       
        // Approve the submitted request
        // First, get the ID of the newly created item
         
        
  
List<Id> newWorkItemIds = result2.getNewWorkitemIds();
        
          // Instantiate the new ProcessWorkitemRequest object and populate it
         approval.ProcessWorkitemRequest req2 =new approval.ProcessWorkitemRequest();
        req2.setComments(' Rejected');
        req2.setAction('Reject');
        req2.setNextApproverIds(new Id[]{userinfo.getUserId()});
        
    
           // Use the ID from the newly created item to specify the item to be worked
        req2.setWorkitemId(newWorkItemIds.get(0));
        
         // Submit the request for approval
         result2 =  Approval.process(req2);
        system.debug(result2);
        
        // Verify the results
        System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
        
        System.assertEquals(
            'Rejected', result2.getInstanceStatus(), 
            'Instance Status'+result2.getInstanceStatus());
        pcs2.Reason_of_Rejection__c=req2.getComments();
        system.debug(pcs2.Reason_of_Rejection__c);
  
        
        
        pcs2=[select id , name,Stages__c from Purchase_Contracts__c where name='ContTest2' ];
         system.debug(pcs2.Stages__c);
        }
}