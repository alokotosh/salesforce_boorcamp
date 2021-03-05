/**
 * @File Name          : HousingProjectTriggerHandlerTest.cls
 * @Description        : 
 * @Author             : =
 * @Group              : 
 * @Last Modified By   : lvoloshchak
 * @Last Modified On   : 16/1/2020
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11/26/2019       Initial Version
**/
@isTest
public class HousingProjectTriggerHandlerTest {
    
    @TestSetup
    static void makeData(){
        Account acc = DataFactory.generateAccountWithAddress(true);
        Contact cnt = DataFactory.generateContactForAccount(acc.Id, true);
        Housing_Project__c project = DataFactory.generateHousingProject(cnt, true);
        Housing_Project__c proj = DataFactory.generateHousingProject(cnt, true); 
        npsp__Address__c accAddress = [SELECT Id FROM npsp__Address__c];
        proj.Address__c = accAddress.Id;
        project.Address__c = accAddress.Id;
        update proj;
        update project;     

        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 150; ++i) {
            contacts.add(new Contact(LastName = 'con'+i, AccountId = acc.id));
        }
        insert contacts;
        List<Housing_Project__c> projects = new List<Housing_Project__c>();
        Date myDatePast = date.newinstance(2019, 2, 17);
        for (Integer i = 0; i < 150; ++i) {
            Date myDate;
            if(i < 75){
                myDate = myDatePast;
            } else {
                myDate = Date.today();
            }
            projects.add(new Housing_Project__c(
                Project_Open_Date__c = myDate,
                Address__c = accAddress.Id, 
                Primary_Applicant__c = contacts.get(i).id, 
                Historic_Preservation_Required__c = 'Yes'
            ));
        }
        insert projects;
    }

    @isTest
    static void checkProjectAssignmentsTest(){

        Housing_Project__c prj = [SELECT Id, RecordTypeId_Copy__c, RecordTypeId, Address__c FROM Housing_Project__c LIMIT 1];
        System.assertEquals(prj.RecordTypeId_Copy__c, prj.RecordTypeId);

        Account acc = [SELECT Id, LifeTime__c, Current_Year__c FROM Account];

        npsp__Address__c accAddress = [SELECT Id FROM npsp__Address__c];
        if (accAddress != null) {
            prj.Address__c = accAddress.Id;
        }
        update prj;

        Housing_Project__c prj_upd = [SELECT Id, Address__c, Address_Copy__c FROM Housing_Project__c LIMIT 1];
        System.assertEquals(prj_upd.Address__c, prj_upd.Address_Copy__c);
    }

    @isTest
    static void changeStatusToClosedTest(){

        Account account = [SELECT Id, LifeTime__c, Current_Year__c FROM Account];
        npsp__Address__c addr = [SELECT Id, LifeTime__c, Current_Year__c FROM npsp__Address__c WHERE npsp__Household_Account__c = :account.id];
        System.assertEquals(0, account.LifeTime__c);
        System.assertEquals(0, account.Current_Year__c);
        System.assertEquals(0, addr.LifeTime__c);
        System.assertEquals(0, addr.Current_Year__c);

        List<Housing_Project__c> projects = [SELECT Id, Address__c, Primary_Applicant__c, Final_Total_Cost__c FROM Housing_Project__c];
        for (Housing_Project__c proj : projects) {
            proj.Final_Total_Cost__c = 1;
            proj.Project_Status_Milestone__c = 'Closed';
        }
        Test.startTest();
        update projects;
        Test.stopTest();
        Account accountAfter = [SELECT Id, LifeTime__c, Current_Year__c FROM Account];
        npsp__Address__c addrAfter = [SELECT Id, LifeTime__c, Current_Year__c FROM npsp__Address__c WHERE npsp__Household_Account__c = :accountAfter.id];
        System.assertEquals(projects.size(), accountAfter.LifeTime__c);
        System.assertEquals(75, accountAfter.Current_Year__c);
        System.assertEquals(projects.size(), addrAfter.LifeTime__c);
        System.assertEquals(75, addrAfter.Current_Year__c);

    }

    @isTest
    static void createOpportunityTest() {

        List<Housing_Project__c> projects = new List<Housing_Project__c>();
        for (Integer i = 0; i <= 200; i++) {
            Housing_Project__c prj = new Housing_Project__c();
            prj.Historic_Preservation_Required__c = 'Yes';
            projects.add(prj);
        }

        insert projects;

        List<Opportunity> oppList = [SELECT Id FROM Opportunity];
        System.assertEquals(oppList.size() >= projects.size(), true);

    }
}