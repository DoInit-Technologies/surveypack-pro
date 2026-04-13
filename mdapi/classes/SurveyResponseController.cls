public with sharing class SurveyResponseController {
    @AuraEnabled
    public static Survey_Response__c submitResponse(Id templateId, Id contactId, Decimal npsScore, Decimal csatScore, String textFeedback) {
        Survey_Response__c resp = new Survey_Response__c(
            Survey_Template__c = templateId,
            Contact__c = contactId,
            NPS_Score__c = npsScore,
            CSAT_Score__c = csatScore,
            Free_Text_Feedback__c = textFeedback,
            Status__c = 'Completed'
        );
        insert resp;
        return resp;
    }

    @AuraEnabled(cacheable=true)
    public static List<Survey_Response__c> getResponsesForContact(Id contactId) {
        return [SELECT Id, Survey_Template__r.Industry__c, NPS_Score__c, CSAT_Score__c, Status__c, Free_Text_Feedback__c FROM Survey_Response__c WHERE Contact__c = :contactId ORDER BY CreatedDate DESC LIMIT 20];
    }

    @InvocableMethod(label='Create Survey Response' description='Called by Flow')
    public static void createResponseFromFlow(List<FlowInputs> inputs) {
        List<Survey_Response__c> toInsert = new List<Survey_Response__c>();
        for (FlowInputs input : inputs) {
            toInsert.add(new Survey_Response__c(
                Survey_Template__c = input.templateId,
                Contact__c = input.contactId,
                Status__c = 'Sent'
            ));
        }
        insert toInsert;
    }

    public class FlowInputs {
        @InvocableVariable(label='Template ID' required=true)
        public Id templateId;
        @InvocableVariable(label='Contact ID' required=true)
        public Id contactId;
    }
}
