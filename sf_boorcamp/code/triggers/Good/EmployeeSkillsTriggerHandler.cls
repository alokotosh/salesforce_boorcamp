/**
 * Created by andrewlokotosh on 7/21/17.
 */

public  class EmployeeSkillsTriggerHandler {

    public static void onAfterInsert(Map<id, EmployeeSkills__c> insertdNewMap) {

        EmployeeSkillsHelper.updateProjectDevQA(insertdNewMap);
    }

    public static void onAfterUpdate(Map<id, EmployeeSkills__c> insertdNewMap, Map<id, EmployeeSkills__c> insertdOldMap) {


    }

    public static void onAfterDelete(Map<id, EmployeeSkills__c> deletedMap) {


    }

    public static void onAfterUnDelete(Map<id, EmployeeSkills__c> undeletedMap) {


    }

}