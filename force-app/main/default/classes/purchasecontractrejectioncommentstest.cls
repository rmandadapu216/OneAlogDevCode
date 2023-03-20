@isTest(SeeAllData=false)
public class purchasecontractrejectioncommentstest {
    
    static testMethod void RejectionProcessWithComments(){

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
     
     
     ///Starts - Rejection Process
     
     
	 	//pc.ContractRejected__c = true;
       
    	List<Id> newWorkItemIds = result.getNewWorkItemIds();  
     	//ID piwiID = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem 
        //          WHERE ProcessInstance.TargetObjectId =: newWorkItemIds].ID;
      	Approval.ProcessWorkitemRequest testRej = new Approval.ProcessWorkitemRequest();
        testRej.setComments('Please mention Comments for Rejection');
        testRej.setAction  ('Reject');
        //testRej.setWorkitemId(newWorkItemIds);
       // testRej.setNextApproverIds(new Id[] {UserInfo.getUserId()});    	
    	//Use the ID from the newly created item to specify the item to be worked
    	testRej.setWorkItemId(newWorkItemIds.get(0));
     	


        Test.startTest();        
                       Approval.ProcessResult testRejResult =  Approval.process(testRej);
        Test.stopTest();
     

        System.assert(testRejResult.isSuccess(), 'Rejections that include comments should be permitted');
        System.assertEquals('Rejected', testRejResult.getInstanceStatus(), 
          'Rejections that include comments should be successful and instance status should be Rejected');
 
         pc = [select id, ContractRejected__c from Purchase_Contracts__c where name = 'Purchase Contracts1'];
     	system.debug('pc.ContractRejected__c - ' + pc.ContractRejected__c);
     
          
       //Ends - Rejection Process
   
                 
    }
    
    static testMethod void RejectionProcessWithoutComments(){

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
     
     
     ///Starts - Rejection Process
     
     
	 	//pc.ContractRejected__c = true;
   
    	List<Id> newWorkItemIds = result.getNewWorkItemIds();  
     	//ID piwiID = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem 
        //          WHERE ProcessInstance.TargetObjectId =: newWorkItemIds].ID;
      	Approval.ProcessWorkitemRequest testRej = new Approval.ProcessWorkitemRequest();
        testRej.setComments(null);
        testRej.setAction  ('Reject');
        //testRej.setWorkitemId(newWorkItemIds);
       // testRej.setNextApproverIds(new Id[] {UserInfo.getUserId()});    	
    	//Use the ID from the newly created item to specify the item to be worked
    	testRej.setWorkItemId(newWorkItemIds.get(0));
     	 

        Test.startTest();   
        try
        {
             Approval.ProcessResult testRejResult =  Approval.process(testRej);
        }
        catch  (Exception ex)
      {
            
           Assert.isTrue(ex.getMessage().contains('Please mention Comments for Rejection') );
        }
                      
     Test.stopTest();  
   
        
    }
}