@isTest
private class locktherecordhandlerTest {

  /*  static testMethod void testLockTheRecord() {
        // Create test data
        Account vendor = new Account();
        vendor.Name = 'Test Vendor';
        insert vendor;
        
        Purchase_Contracts__c contract1 = new Purchase_Contracts__c();
        contract1.Name = 'Test Contract 1';
        contract1.Stages__c = 'Cancelled';
        contract1.Cancellation_Reason__c ='Issue';
        contract1.Vendor_Name__c = vendor.Id;
        insert contract1;
        
        Purchase_Contracts__c contract2 = new Purchase_Contracts__c();
        contract2.Name = 'Test Contract 2';
        contract2.Stages__c = 'Closed';
        contract2.Vendor_Name__c = vendor.Id;
        insert contract2;
        
        Purchase_Contracts__c contract3 = new Purchase_Contracts__c();
        contract3.Name = 'Test Contract 3';
        contract3.Stages__c = 'Initiation';
        contract3.Vendor_Name__c = vendor.Id;
        insert contract3;
        
        // Set the IsLocked__c field for contract1,2
        contract1.IsLocked__c = true;
        update contract1;
        contract2.IsLocked__c = true;
        update contract2;
        
        // Call the handler method
        List<Purchase_Contracts__c> contractsToUpdate = new List<Purchase_Contracts__c>{contract1, contract2};
        Map<Id, Purchase_Contracts__c> oldContractsMap = new Map<Id, Purchase_Contracts__c>{
            contract1.Id => contract1,
            contract2.Id => contract2,
            contract3.Id => contract3
        };
        System.debug('*** Starting testLockTheRecord ***');
        System.debug('*** Calling lockTheRecord method ***');
        locktherecordhandler.lockTheRecord(contractsToUpdate, oldContractsMap);
        System.debug('*** lockTheRecord method completed ***');
        
        // Verify the results
        List<Purchase_Contracts__c> updatedContracts = [SELECT Id, IsLocked__c, Stages__c FROM Purchase_Contracts__c WHERE Id IN :contractsToUpdate];
        System.assertEquals(2, updatedContracts.size(), 'Expected 2 records to be updated');
        for(Purchase_Contracts__c updatedContract : updatedContracts) {
            if(updatedContract.Stages__c == 'Cancelled' || updatedContract.Stages__c == 'Closed') {
                System.assertEquals(true, updatedContract.IsLocked__c, 'Expected IsLocked__c field to be true');
            } else {
                if(updatedContract.Stages__c != 'Cancelled' || updatedContract.Stages__c != 'Closed'){
                //System.assertEquals(false, updatedContract.IsLocked__c, 'Expected IsLocked__c field to be false');
               // System.assertEquals(oldContractsMap.get(updatedContract.Id).Stages__c, updatedContract.Stages__c, 'Expected Stages__c field to be reverted to old value');
               updatedContract.IsLocked__c = true;
                System.assert(updatedContract.HasErrors(), 'Expected record to have an error');}
            }
        }
    }*/
   
        @isTest
   static void testLockTheRecord() {
  // Create test data
        Account vendor = new Account();
        vendor.Name = 'Test Vendor';
        insert vendor;
        
        Purchase_Contracts__c contract1 = new Purchase_Contracts__c();
        contract1.Name = 'Test Contract 1';
        contract1.Stages__c = 'Initiation';
        contract1.Contract_type__c = 'Software';
        contract1.Vendor_Name__c = vendor.Id;
        insert contract1;
       
       Purchase_Contracts__c contract2 = new Purchase_Contracts__c();
        contract2.Name = 'Test Contract 2';
        contract2.Stages__c = 'Initiation';
        contract2.Contract_type__c = 'Software';
        contract2.Vendor_Name__c = vendor.Id;
        insert contract2;
       
       Purchase_Contracts__c contract3 = new Purchase_Contracts__c();
        contract3.Name = 'Test Contract 3';
        contract3.Stages__c = 'Initiation';
        contract3.Contract_type__c = 'Software';
        contract3.Vendor_Name__c = vendor.Id;
        insert contract3;
       
        contract1.Cancellation_Reason__c ='Cancelled Issue';
        contract1.Stages__c = 'Cancelled';
        update contract1;
       
       contract2.Reasons_for_Termination__c ='Termination Issue';
        contract2.Stages__c = 'Termination';
        update contract2;
       
       Contract_Material__c mat1 = new Contract_Material__c();
       		mat1.Name = 'contract3 material';
       		mat1.Purchase_Contract__c = contract3.Id;
       		mat1.Unit_Of_Measurement__c = 'Each';
       		mat1.Unit_Price__c = 200;
       		mat1.Quantiy__c = 10;
       Insert mat1;
       
        contract3.Stages__c = 'Execution';
        contract3.Contract_Term__c = 2;
        contract3.Delivery_Schedule__c = 'Weekly';
        //contract3.IsLocked__c = True;
        update contract3;
       
       //contract3.Stages__c = 'Approved';
       //update contract3;

 		//contract3.Stages__c = 'Execution';
        contract3.Execution_Date__c = system.today();
       //	update contract3;
       
       contract3.Stages__c = 'Closed';
       	update contract3;
       
       List<Purchase_Contracts__c> updatedContracts = [SELECT Id, IsLocked__c, Stages__c FROM Purchase_Contracts__c Limit 3];
       
       	Test.startTest();
        Database.SaveResult[] results = Database.Update(updatedContracts, false);
        Test.stopTest();
       
        for(Database.SaveResult dr : results) {
            System.assert(!dr.isSuccess());
            System.assert(dr.getErrors().size() > 0);
            System.assertEquals('Record is Locked',
                                 dr.getErrors()[0].getMessage());
        }
    }

}