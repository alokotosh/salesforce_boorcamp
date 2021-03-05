/**
 * @description: Helper Class For Milestones Trigger functionality
 * @author: andrewlokotosh
 * @date: 8/17/17
 *
 */

public  class PSO_M_TempalteDetailHelper {


    private static final String TEMPLATE_APPROVED = 'Active';
    private static final String RECORD_TYPE_MILESTONE_TRACKING_FOR_STUDY = 'Milestone_Tracking_for_Study';
    private static final String RECORD_TYPE_MILESTONE_TRACKING_FOR_COUNTRY = 'Milestone_Tracking_for_Country';
    private static final String RECORD_TYPE_MILESTONE_TRACKING_FOR_SITE = 'Milestone_Tracking_for_Site';


    public enum Level {  COUNTRY, SITE, STUDY, ALL }
    public enum RecordStatus { CREATED, CHANGED, APPROVED }


    private static Map<String, Id> milestoneRecordTypesMap {

        private get {
            if (milestoneRecordTypesMap == null) {
                milestoneRecordTypesMap = new Map<String, Id>();
                for (RecordType rtItem : [SELECT id, DeveloperName FROM RecordType WHERE sObjectType = :PSO_DT_Constants.OBJECT_MILESTONE_TRACKING_NAME]) {
                    milestoneRecordTypesMap.put(rtItem.DeveloperName, rtItem.Id);
                }
            }
            return milestoneRecordTypesMap;
        }
        private set;
    }

    private static Map<String, Level> levelNameMap {

        private get {
            if (levelNameMap == null) {
                levelNameMap = new Map<String, Level>();
                levelNameMap.put('ALL', Level.All);
                levelNameMap.put('SITE', Level.SITE);
                levelNameMap.put('COUNTRY', Level.COUNTRY);
                levelNameMap.put('STUDY', Level.STUDY);
            }
            return levelNameMap;
        }
        private set;
    }





    /**
     * @description Function to change the Record Status
     * @author      Andriy Lokotosh
     * @date        Created: 14-Aug-2017
    */

    public static void setRecordStatus(List<Milestone_Template_Detail__c> records, RecordStatus status) {

        for (Milestone_Template_Detail__c record: records) {
            if (status == RecordStatus.CREATED) {
                record.Record_Status__c = String.valueOf(status);
            } else if (status == RecordStatus.CHANGED) {
                //TODO need logic when Milestone Tempalte Detail is changed
                //record.isActive__c = false;
            }
        }

    }



    /**
     * @description Function to populate Milestone Record Type depends on Level
     * @author      Andriy Lokotosh
     * @date        Created: 18-Aug-2017
     * @event       Before Insert
     * @param       records: Milestone Tracking records
    */

    public static void  populateMilestoneTrackingRecordType(List<Milestone_Tracking__c> records){


        for (Milestone_Tracking__c recordEach: records) {
            if (String.isNotEmpty(recordEach.Study_Id__c)){

                recordEach.RecordTypeid = milestoneRecordTypesMap.get(RECORD_TYPE_MILESTONE_TRACKING_FOR_STUDY);
            } else if (String.isNotEmpty(recordEach.Country_Id__c) ) {
                recordEach.RecordTypeid = milestoneRecordTypesMap.get(RECORD_TYPE_MILESTONE_TRACKING_FOR_COUNTRY);
            } else if (String.isNotEmpty(recordEach.Clinical_Site_Id__c)) {
                recordEach.RecordTypeid = milestoneRecordTypesMap.get(RECORD_TYPE_MILESTONE_TRACKING_FOR_SITE);
            }
        }
    }



    /**
     * @description Function to make deep queary according to the params
     * @author      Andriy Lokotosh
     * @date        Created: 21-Aug-2017
     * @param       studyIds: related Studies id
     * @param       childsActive: records should be active?
     * @param       status: record status (CREATED, APPROVED)
     * @return      map of Tracking Tempalte records and chields
    */

    private static Map<id, Tracking_Template__c> getTempaltesAndChilds(Set<Id> studyIds,Boolean childsActive, String recordStatus) {

        return new Map<id, Tracking_Template__c>([Select Id,
                Name,
                OwnerId,
                Status__c,
                Global_Usage__c,
                Reviewer__c,
                Study_Id__c,
                Template_Description__c,
                Template_Type__c,
                Usage_Level__c,
                Template_Version__c,
        (Select Id,
                Name,
                Study__c,
                Country__c,
                Clinical_Site__c,
                Milestone_Template__c,
                Milestone_Template__r.Study_Id__c,
                isActive__c,
                Unique_Milestone_Name__c,
                S_NO__c,
                Unique_Milestone_Library__c,
                Unique_Milestone_Library__r.Name,
                Intervals__c,
                Internal_Flag__c
        From Milestone_Template_Details__r
        WHERE Record_Status__c =: recordStatus
        AND isActive__c =: childsActive
        LIMIT 1000)
        From Tracking_Template__c
        Where Study_Id__c IN :studyIds
        AND Global_Usage__c = false
        AND Status__c = : TEMPLATE_APPROVED
        LIMIT 1000]);
    }

    /**
     * @description Function to auto generate milestones according to the level
     * @author      Andriy Lokotosh
     * @date        Created: 21-Aug-2017
     * @param       studyIds: related Studies id
     * @param       detailLevel: record level (SITE,COUNTRY,ALL)
    */

    @future
    public static void autoGenerateMilestones(Set<Id> studyIds, String detailLevel, Boolean activeRecords, String recordStatus, Set<Id> sObjectIds) {

        Map<id, Clinical_Study__c> idToStudy;
        if (detailLevel == String.valueOf(Level.ALL)) {
            idToStudy = new Map<id, Clinical_Study__c>([SELECT id,Name, (SELECT id FROM StudyCountries__r), (SELECT id FROM Clinical_Sites__r) FROM Clinical_Study__c WHERE id IN : studyIds]);
        } else {
            idToStudy = new Map<id, Clinical_Study__c>([SELECT id,Name, (SELECT id FROM StudyCountries__r WHERE Id IN : sObjectIds), (SELECT id FROM Clinical_Sites__r WHERE Id IN : sObjectIds) FROM Clinical_Study__c WHERE id IN : studyIds]);
        }

        Map<id, Tracking_Template__c> relatedTrackings = getTempaltesAndChilds(studyIds, activeRecords, recordStatus);
        System.debug('list '  + relatedTrackings);
        System.debug('study '  + studyIds);
        System.debug('level '  + detailLevel);
        Map<Clinical_Study__c,Map<Tracking_Template__c,MDT_Level>> sortedMDTMap = new Map<Clinical_Study__c,Map<Tracking_Template__c,MDT_Level>>();

        for(Clinical_Study__c studyItem: idToStudy.values()) {

            Map<Tracking_Template__c,MDT_Level> relateToStudyMap = new Map<Tracking_Template__c,MDT_Level>();

            for (Tracking_Template__c templateItem: relatedTrackings.values()){
                
                if (templateItem.Study_Id__c == studyItem.id) {
                    relateToStudyMap.put(templateItem, sortMDT(templateItem.Milestone_Template_Details__r));
                }
            }
            sortedMDTMap.put(studyItem,relateToStudyMap);
            relateToStudyMap = null;

        }
        formingMilestoneTrackingRecords(sortedMDTMap, levelNameMap.get(detailLevel));

    }

    /**
     * @description Function to create all Milestones
     * @author      Andriy Lokotosh
     * @date        Created: 21-Aug-2017
     * @param       sortedMDTMap: sorted Map with all childs according to level
     * @param       detailLevel: record level (SITE,COUNTRY,ALL)
    */

    private static void formingMilestoneTrackingRecords( Map<Clinical_Study__c,Map<Tracking_Template__c,MDT_Level>> sortedMDTMap, Level detailLevel ){

        List<Milestone_Tracking__c> allNewTrackings = new List<Milestone_Tracking__c>();

        for (Clinical_Study__c studyItem : sortedMDTMap.keySet()) {
            List<MDT_Level> studyRelatedMilestones = sortedMDTMap.get(studyItem).values();

            if (detailLevel == Level.COUNTRY) {
                for (Study_Country__c countryItem : studyItem.StudyCountries__r) {
                    for (MDT_Level levelItem: studyRelatedMilestones) {
                        allNewTrackings.addAll(creationMilestoneTrackingHelper(levelItem.countryLevel, Level.COUNTRY, countryItem.id));
                    }
                }
            } else if (detailLevel == Level.Site) {

                for (Clinical_Site__c siteItem : studyItem.Clinical_Sites__r) {
                    for (MDT_Level levelItem: studyRelatedMilestones) {
                        allNewTrackings.addAll(creationMilestoneTrackingHelper(levelItem.siteLevel, Level.SITE, siteItem.id));
                    }
                }
            } else if (detailLevel == Level.ALL) {
                for (Study_Country__c countryItem : studyItem.StudyCountries__r) {
                    for (MDT_Level levelItem: studyRelatedMilestones) {
                        allNewTrackings.addAll(creationMilestoneTrackingHelper(levelItem.countryLevel, Level.COUNTRY, countryItem.id));
                    }
                }

                for (Clinical_Site__c siteItem : studyItem.Clinical_Sites__r) {
                    for (MDT_Level levelItem: studyRelatedMilestones) {
                        allNewTrackings.addAll(creationMilestoneTrackingHelper(levelItem.siteLevel, Level.SITE, siteItem.id));

                    }
                }
                for (MDT_Level levelItem: studyRelatedMilestones) {
                    allNewTrackings.addAll(creationMilestoneTrackingHelper(levelItem.studyLevel, Level.STUDY, studyItem.id));
                }
                System.debug('all details '+ studyRelatedMilestones );
                approveMilestoneDetails(studyRelatedMilestones);

            }

        }

        if (!allNewTrackings.isEmpty()) {
            try {
                System.debug('allNewTrackings '+ allNewTrackings);
                insert allNewTrackings;


            } catch (Exception e){
                System.debug('Exc '+ e.getMessage());
            }
        }
    }

    private static void approveMilestoneDetails(List<MDT_Level> studyRelatedMilestones) {

        Set<Milestone_Template_Detail__c> tobeApproved = new  Set<Milestone_Template_Detail__c>();

        for (MDT_Level levelItem: studyRelatedMilestones) {
            for (Milestone_Template_Detail__c detailItem:  levelItem.allToApprove) {

                detailItem.isActive__c = true;
                detailItem.Record_Status__c = String.valueOf(RecordStatus.APPROVED);
                tobeApproved.add(detailItem);
            }
        }
        System.debug('all APP '+ tobeApproved );
        if (!tobeApproved.isEmpty()) {
            try {
                update new List<Milestone_Template_Detail__c>(tobeApproved);

            } catch (Exception e){
                System.debug('Exc '+ e.getMessage());
            }
        }
    }

    /**
     * @description Function to generate Milestone Tracking Level
     * @author      Andriy Lokotosh
     * @date        Created: 21-Aug-2017
     * @param       relatedRecords: template detail records
     * @param       detailLevel: record level (SITE,COUNTRY,ALL)
     * @param       sObjectId: sObject id (SITE,CONTRY or STUDY)
     * @return      newTrackings: new generated Milestone Tracking records
    */

    private static List<Milestone_Tracking__c> creationMilestoneTrackingHelper(List<Milestone_Template_Detail__c> relatedRecords, Level detailLevel, Id sObjectId){
        List<Milestone_Tracking__c> newTrackings = new List<Milestone_Tracking__c>();



        for (Milestone_Template_Detail__c detailItem:  relatedRecords) {

            Milestone_Tracking__c mileStoneTracking = new Milestone_Tracking__c();
            mileStoneTracking.Template_Id__c = detailItem.Milestone_Template__c;
            mileStoneTracking.Milestone_Template_Detail__c =  detailItem.id;
            mileStoneTracking.Unique_Milestone_Library__c = detailItem.Unique_Milestone_Library__c;
            mileStoneTracking.S_NO__c = detailItem.S_NO__c;
            mileStoneTracking = determinateMilestoneTrackingLevel(mileStoneTracking, detailLevel, sObjectId);
            newTrackings.add(mileStoneTracking);
        }

        populateMilestoneTrackingRecordType(newTrackings);

        return newTrackings;
    }

    /**
     * @description Function to determinate Milestone Tracking level SITE,CONTRY or STUDY) and populate related id
     * @author      Andriy Lokotosh
     * @date        Created: 21-Aug-2017
     * @param       mtRecord: Milestone Tracking records
     * @param       trackingLevel: record level (SITE,COUNTRY,ALL)
     * @param       sObjectId: sObject id (SITE,CONTRY or STUDY)
    */

    private static  Milestone_Tracking__c determinateMilestoneTrackingLevel(Milestone_Tracking__c mtRecord, Level trackingLevel, Id sObjectId) {

        if (trackingLevel ==  Level.COUNTRY) {
            mtRecord.Country_Id__c = sObjectId;
        } else if (trackingLevel ==  Level.SITE) {
            mtRecord.Clinical_Site_Id__c = sObjectId;
        } else if (trackingLevel ==  Level.STUDY) {
            mtRecord.Study_Id__c = sObjectId;

        }
        System.debug('Milestone record ' +mtRecord );
        return mtRecord;
    }


    /**
     * @description Function to sort M. T. D. records acording to level
     * @author      Andriy Lokotosh
     * @date        Created: 21-Aug-2017
     * @param       details: M. T. D. records from Template
     * @return      MDT_Level wrapper class
    */

    private static  MDT_Level sortMDT(List<Milestone_Template_Detail__c> details) {
        System.debug('details '+ details);
        MDT_Level mdtHelper = new MDT_Level(new List<Milestone_Template_Detail__c>(), new List<Milestone_Template_Detail__c>(), new List<Milestone_Template_Detail__c>(), new List<Milestone_Template_Detail__c>());
        for( Milestone_Template_Detail__c detailItem : details) {

            if(detailItem.Study__c) {
                mdtHelper.studyLevel.add(detailItem);
            }

            if (detailItem.Country__c){
                mdtHelper.countryLevel.add(detailItem);
            }

            if (detailItem.Clinical_Site__c) {
                mdtHelper.siteLevel.add(detailItem);
            }

            mdtHelper.allToApprove.add(detailItem);
        }
        System.debug('helper '+ mdtHelper);
        return mdtHelper;
    }

    /**
     * @description class to keep sorted M.T.D records
     * @author      Andriy Lokotosh
     * @date        Created: 21-Aug-2017
    */


    private class MDT_Level {
        public List<Milestone_Template_Detail__c> studyLevel {get;set;}
        public List<Milestone_Template_Detail__c> countryLevel {get;set;}
        public List<Milestone_Template_Detail__c> siteLevel {get;set;}
        public List<Milestone_Template_Detail__c> allToApprove {get;set;}

        public MDT_Level(List<Milestone_Template_Detail__c> studyLevel, List<Milestone_Template_Detail__c> countryLevel, List<Milestone_Template_Detail__c> siteLevel,  List<Milestone_Template_Detail__c> allToApprove){
            this.studyLevel = studyLevel;
            this.countryLevel = countryLevel;
            this.siteLevel = siteLevel;
            this.allToApprove = allToApprove;
            
        }
    }



}