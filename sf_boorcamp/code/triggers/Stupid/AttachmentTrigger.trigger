trigger AttachmentTrigger on Attachment (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

    TriggerManager.createHandler(Attachment.sObjectType);
    List<Order__c> orderList = new List<Order__c>();
    if (Trigger.isInsert && Trigger.isAfter) {
        List<SObject> attsToProcess = new List<SObject>();
        Map<Id, SObject> attMapToProcess = new Map<Id, SObject>();
        Map<Id, Id> attIdToOrderIdMap = new Map<Id, Id>();
        Set<Id> parentId = new Set<Id>();
        Set<Id> tnpOrderId = new Set<Id>();
        for (SObject so : Trigger.new) {
            Attachment att = (Attachment) so;
            if(att.ParentId.getSobjectType() == Schema.Order__c.SObjectType) {
                attIdToOrderIdMap.put(att.Id, att.ParentId);
            }
            if(att.Name.contains('_TNP')){
                tnpOrderId.add(att.ParentId);
                //att.Decipher_Report_Creation_Date__c = System.now();
            }
        }
        if(!attIdToOrderIdMap.isEmpty()){

            for(Order__c o : [Select id , RecordType.Id , RecordType.Name, Decipher_Report_Creation_Date__c from Order__c Where Id in  : attIdToOrderIdMap.values()]){
                if(o.RecordTypeId != null && o.RecordType.Name.startsWithIgnoreCase('Pro')){
                    parentId.add(o.Id);
                }
                if((!tnpOrderId.isEmpty()) && tnpOrderId.contains(o.Id)){
                    O.Decipher_Report_Creation_Date__c   = System.today();
                    orderList.add(o);
                }
            }
        }
        for (SObject so : Trigger.new) {
            Attachment att = (Attachment) so;
            if (att.ParentId.getSobjectType() == Schema.Sample_Management__c.SObjectType ) {
                //attsToProcess.add(so);
                attMapToProcess.put(so.Id, so);
            }
            if (att.ParentId.getSobjectType() == Schema.Order__c.SObjectType && (!att.Name.contains('_TNP'))) {
                if(!parentId.contains(att.ParentId)){
                    attsToProcess.add(so);
                    attMapToProcess.put(so.Id, so);
                }
            } else if(att.ParentId.getSobjectType() == Schema.Sample_Management__c.SObjectType){
                attsToProcess.add(so);
            }

        }

        if (!attMapToProcess.isEmpty()) {
            AttachmentHelper.prepareRelatedAttachments(attMapToProcess.values(), attMapToProcess);
        }
        if(!attsToProcess.isEmpty()){
            ReportDeliveryHandlerOnAttachment.handle(attsToProcess);
        }
        AttachmentHelper.deleteExistingUnsignedPdf(trigger.new);
    }

    if (Trigger.isBefore && Trigger.isDelete) {
        DeleteRelatedAttachmentHandler.handle(Trigger.old);
        for (sObject obj : Trigger.old) {
            Attachment att = (Attachment) obj;
            if (att.Name.contains('Docusigned') || att.Name.contains('_TNP')) {
                att.addError('You can not delete signed pdf.');
            }
        }
    }
    if(orderList != null && orderList.size()>0)
        update orderList;
}