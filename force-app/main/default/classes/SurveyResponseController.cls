public with sharing class SurveyResponseController {
    @AuraEnabled
    public static Survey_Response__c submitResponse(Id templateId, Id contactId, Decimal npsScore, Decimal csatScore, String textFeedback) {
        Survey_Response__c resp = new Survey_Response__c(
            Survey_Template__c = templateId,
            Contact__c = contactId,
            NPS_Score__c = npsScore,
            CSAT_Score__c = csatScore,
            Free_Text_Feedback__c = textFeedback,
            Response_Date__c = DateTime.now(),
            Status__c = 'Completed'
        );
        insert resp;
        return resp;
    }

    @AuraEnabled
    public static void markOpened(Id responseId) {
        Survey_Response__c resp = [SELECT Id, Status__c FROM Survey_Response__c WHERE Id = :responseId LIMIT 1];
        if (resp.Status__c == 'Sent') {
            resp.Status__c = 'Opened';
            update resp;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Survey_Response__c> getResponsesForContact(Id contactId) {
        return [SELECT Id, Survey_Template__r.Industry__c, NPS_Score__c, CSAT_Score__c, Response_Date__c, Status__c, Free_Text_Feedback__c FROM Survey_Response__c WHERE Contact__c = :contactId ORDER BY Response_Date__c DESC LIMIT 20];
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getResponseStats(Id templateId) {
        List<AggregateResult> results = [
            SELECT Status__c, COUNT(Id) cnt, AVG(NPS_Score__c) avgNPS, AVG(CSAT_Score__c) avgCSAT
            FROM Survey_Response__c
            WHERE Survey_Template__c = :templateId
            GROUP BY Status__c
        ];
        Map<String, Object> stats = new Map<String, Object>();
        Integer total = 0;
        for (AggregateResult ar : results) {
            String status = (String) ar.get('Status__c');
            Integer cnt = (Integer) ar.get('cnt');
            total += cnt;
            stats.put(status, cnt);
            stats.put(status + '_AvgNPS', ar.get('avgNPS'));
            stats.put(status + '_AvgCSAT', ar.get('avgCSAT'));
        }
        stats.put('total', total);
        return stats;
    }

    @InvocableMethod(label='Create Survey Response' description='Called by Flow to create a pending survey response')
    public static void createResponseFromFlow(List<FlowInputs> inputs) {
        List<Survey_Response__c> toInsert = new List<Survey_Response__c>();
        for (FlowInputs input : inputs) {
            toInsert.add(new Survey_Response__c(
                Survey_Template__c = input.templateId,
                Contact__c = input.contactId,
                Response_Date__c = DateTime.now(),
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
