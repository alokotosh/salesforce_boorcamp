/**
 * Created by andrewlokotosh on 8/15/17.
 */

public with sharing class PSO_M_TemplateDetailTriggerHandler extends COM_TriggerHandlerImplementation {

    /**
     * @description Function to be called when the trigger is called on the before insert status
     * @author      Kondal Reddy, Vijay
     * @date        Created: 14-Aug-2017
    */
    public override void onBeforeInsertFunction(){

        PSO_M_TempalteDetailHelper.setRecordStatus(Trigger.NEW, PSO_M_TempalteDetailHelper.RecordStatus.CREATED);
        PSO_MilestonesHelper.checkSequenceUniqueNumber(Trigger.NEW);
    }

    /**
     * @description Function to be called when the trigger is called on the before update status
     * @author      Andriy Lokotosh
     * @date        Created: 14-Aug-2017
    */
    public override void onBeforeUpdateFunction(){
        PSO_MilestonesHelper.checkSequenceUniqueNumber(Trigger.NEW);
        PSO_MilestonesHelper.isTemplateApproved(Trigger.NEW, PSO_MilestonesHelper.ACTION_EDIT);
        PSO_M_TempalteDetailHelper.setRecordStatus(Trigger.NEW, PSO_M_TempalteDetailHelper.RecordStatus.CHANGED);


    }


}