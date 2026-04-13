public with sharing class SurveyDistributionService {
    @AuraEnabled
    public static void distributeSurvey(Id templateId, Id contactId) {
        Survey_Template__c tmpl = [SELECT Id, Name FROM Survey_Template__c WHERE Id = :templateId AND Is_Active__c = true LIMIT 1];
        insert new Survey_Response__c(
            Survey_Template__c = templateId,
            Contact__c = contactId,
            Response_Date__c = DateTime.now(),
            Status__c = 'Sent'
        );
        System.debug('Survey distributed to contact: ' + contactId + ' for template: ' + tmpl.Name);
    }

    @AuraEnabled
    public static Id getActiveTemplateByIndustry(String industry) {
        List<Survey_Template__c> tmpl = [SELECT Id FROM Survey_Template__c WHERE Industry__c = :industry AND Is_Active__c = true LIMIT 1];
        return tmpl.isEmpty() ? null : tmpl[0].Id;
    }
}
