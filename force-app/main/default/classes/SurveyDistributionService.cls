public with sharing class SurveyDistributionService {
    // Map Case.Type -> Survey_Template__c.Industry__c
    private static final Map<String, String> CASE_TYPE_TO_INDUSTRY = new Map<String, String>{
        'Mechanical'   => 'Auto',
        'Electrical'  => 'Auto',
        'Electronic'  => 'Auto',
        'Structural'   => 'Retail',
        'Other'       => 'Retail'
    };

    @AuraEnabled(cacheable=true)
    public static Id getTemplateIdByIndustry(String industry) {
        List<Survey_Template__c> tmpl = [SELECT Id FROM Survey_Template__c WHERE Industry__c = :industry LIMIT 1];
        return tmpl.isEmpty() ? null : tmpl[0].Id;
    }

    @AuraEnabled
    public static Id createSurveyResponse(Id templateId, Id contactId) {
        Survey_Response__c resp = new Survey_Response__c(
            Survey_Template__c = templateId,
            Contact__c = contactId,
            Status__c = 'Sent'
        );
        insert resp;
        return resp.Id;
    }

    @AuraEnabled
    public static Id distributeSurvey(Id templateId, Id contactId) {
        Id respId = createSurveyResponse(templateId, contactId);
        System.debug('Survey distributed to contact: ' + contactId + ', template: ' + templateId);
        return respId;
    }

    @Future
    public static void distributeSurveyForCase(Id caseId) {
        Case c = [SELECT Id, ContactId, Type FROM Case WHERE Id = :caseId LIMIT 1];
        if (c.ContactId == null || String.isBlank(c.Type)) {
            System.debug('Case ' + c.Id + ' has no contact or type — skipping');
            return;
        }
        String industry = CASE_TYPE_TO_INDUSTRY.get(c.Type);
        if (industry == null) {
            System.debug('No industry mapping for Case.Type: ' + c.Type);
            return;
        }
        Id templateId = getTemplateIdByIndustry(industry);
        if (templateId == null) {
            System.debug('No active template found for industry: ' + industry);
            return;
        }
        Id respId = createSurveyResponse(templateId, c.ContactId);
        System.debug('Survey distributed for Case ' + c.Id + ' (Type=' + c.Type + ') -> Response: ' + respId);
    }
}
