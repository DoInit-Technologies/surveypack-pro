public with sharing class SurveyTemplateController {
    @AuraEnabled(cacheable=true)
    public static List<Survey_Template__c> getActiveTemplates() {
        return [SELECT Id, Name, Industry__c, Is_Active__c, Description__c FROM Survey_Template__c WHERE Is_Active__c = true ORDER BY Industry__c ASC];
    }

    @AuraEnabled(cacheable=true)
    public static List<Survey_Template__c> getAllTemplates() {
        return [SELECT Id, Name, Industry__c, Is_Active__c, Description__c FROM Survey_Template__c ORDER BY Industry__c ASC];
    }

    @AuraEnabled
    public static Survey_Template__c getTemplateWithQuestions(Id templateId) {
        return [SELECT Id, Name, Industry__c, Is_Active__c, Description__c, Questions_JSON__c FROM Survey_Template__c WHERE Id = :templateId LIMIT 1];
    }

    @AuraEnabled
    public static void activateTemplate(Id templateId) {
        Survey_Template__c tmpl = [SELECT Id, Is_Active__c FROM Survey_Template__c WHERE Id = :templateId LIMIT 1];
        tmpl.Is_Active__c = true;
        update tmpl;
    }

    @AuraEnabled
    public static void deactivateTemplate(Id templateId) {
        Survey_Template__c tmpl = [SELECT Id, Is_Active__c FROM Survey_Template__c WHERE Id = :templateId LIMIT 1];
        tmpl.Is_Active__c = false;
        update tmpl;
    }

    @AuraEnabled
    public static Survey_Template__c createTemplate(String name, String industry, String description) {
        Survey_Template__c tmpl = new Survey_Template__c(Name = name, Industry__c = industry, Description__c = description, Is_Active__c = false);
        insert tmpl;
        return tmpl;
    }

    @AuraEnabled
    public static String getQuestionsJson(Id templateId) {
        Survey_Template__c tmpl = [SELECT Questions_JSON__c FROM Survey_Template__c WHERE Id = :templateId LIMIT 1];
        return tmpl.Questions_JSON__c;
    }

    @AuraEnabled
    public static void saveQuestionsJson(Id templateId, String questionsJson) {
        Survey_Template__c tmpl = [SELECT Id, Questions_JSON__c FROM Survey_Template__c WHERE Id = :templateId LIMIT 1];
        tmpl.Questions_JSON__c = questionsJson;
        update tmpl;
    }
}
