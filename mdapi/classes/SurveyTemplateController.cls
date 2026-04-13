public with sharing class SurveyTemplateController {
    @AuraEnabled(cacheable=true)
    public static List<Survey_Template__c> getAllTemplates() {
        return [SELECT Id, Name, Industry__c FROM Survey_Template__c ORDER BY Industry__c ASC];
    }

    @AuraEnabled(cacheable=true)
    public static List<Survey_Template__c> getTemplatesByIndustry(String industry) {
        return [SELECT Id, Name, Industry__c FROM Survey_Template__c WHERE Industry__c = :industry ORDER BY Name ASC];
    }

    @AuraEnabled(cacheable=true)
    public static Id getTemplateIdByIndustry(String industry) {
        List<Survey_Template__c> tmpl = [SELECT Id FROM Survey_Template__c WHERE Industry__c = :industry LIMIT 1];
        return tmpl.isEmpty() ? null : tmpl[0].Id;
    }
}
