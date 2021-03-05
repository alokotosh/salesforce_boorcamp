trigger QAsAndDevSummary on EmployeeSkills__c (after insert, after update) {
    
    if ( Trigger.isInsert || Trigger.isUpdate ){            
        Id[] pIds = new List<Id>();
        for(EmployeeSkills__c e: trigger.new){
                pIds.add(e.Project__c);      
        }
        
        String depQA = 'QA';
        String depDev = 'Software Development';
            
        List<Employee__c> employees = [
            SELECT Name, Department__c
            FROM Employee__c 
            WHERE Id IN (
                SELECT Employee__c 
                FROM EmployeeSkills__c 
                WHERE Project__r.Id =: pIds) 
            AND (Department__c =: depQA 
                 OR Department__c =: depDev)];
        
        Integer qas = 0;
        Integer devs = 0;
        for(Employee__c e : employees){
            if(e.Department__c == depQA){
                qas++;
            } else {
                devs++;
            }
        }	
        
        List<Project__c> projects = [
            SELECT Id, QAs__c, Developers__c 
            FROM Project__c 
            WHERE Id IN :pIds];
        
        for(Project__c p : projects){
            if(qas != 0) {
                p.QAs__c = qas;
            }
            if(devs != 0) {
                p.Developers__c = devs;
            }
        }
        
        update projects;        
    }
     
}