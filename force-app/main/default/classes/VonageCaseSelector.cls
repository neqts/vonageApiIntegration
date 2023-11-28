public inherited sharing class VonageCaseSelector {
    public static Case selectCaseById(Id caseId){
        return selectMultipleCasesByIds(new Set<Id>{caseId})[0]; 
    }
    public static List<Case> selectMultipleCasesByIds(Set<Id> caseIds){
        return [SELECT Id, CaseNumber, Subject FROM Case WHERE Id IN : caseIds]; 
    }
}