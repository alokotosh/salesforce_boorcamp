/**
 * @description:
 * @author: Andriy Lokotosh
 * @date: ${DATE}
 *
 */


trigger PSO_MilestoneTrackingTrigger on Milestone_Tracking__c (before insert, after insert) {

    COM_TriggerPattern_API.executeObjectTriggerHandlers(PSO_DT_Constants.OBJECT_MILESTONE_TRACKING_NAME);
    COM_Audit_Trail_API.executeAuditTrail(PSO_DT_Constants.OBJECT_MILESTONE_TRACKING_NAME, PSO_DT_Constants.OBJECT_MILESTONE_TRACKING_NAME);
}