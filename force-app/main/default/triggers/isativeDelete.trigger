trigger isativeDelete on Account (before delete)
{
    if(trigger.isbefore && trigger.isdelete)
    {
        for(Account lstrec : trigger.old)
        {
            if(lstrec.Vendor_Status2__c == 'Active')
            {
                lstrec.addError('You can not delete the active vendor record');
            }
        }
    }
}