trigger PSO_DT_Tracking_Template_Trigger on Tracking_Template__c (after insert,
                                                                  after update,
                                                                  after delete,
                                                                  after undelete,
                                                                  before update,
                                                                  before delete,
                                                                  before insert) {
    //Dynamically instantiate the handler(s)
    List<ICOM_TriggerHandler> handlers = COM_TriggerPattern_API.getObjectTriggerHandlers(PSO_DT_Constants.OBJECT_TRACKING_TEMPLATE_NAME);
    for(ICOM_TriggerHandler handler : handlers){
        if(Trigger.isBefore){
            if(Trigger.isInsert){                
                handler.onBeforeInsertFunction();                
            }
            if(Trigger.isUpdate){                
                handler.onBeforeUpdateFunction();                
            }
            if(Trigger.isDelete){                
                handler.onBeforeDeleteFunction();                
            }
        }
        
        if(Trigger.isAfter){
            if(Trigger.isInsert){
                handler.onAfterInsertFunction();                
            }
            if(Trigger.isUpdate){
                handler.onAfterUpdateFunction();                
            }
            if(Trigger.isDelete){
                handler.onAfterDeleteFunction();                
            }
            if(Trigger.isUnDelete){
                handler.onAfterUnDeleteFunction();                
            }
        }
    }   
}