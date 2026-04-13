// SurveyPack Pro — Sample Data Creator
// Run: sfdx force:apex:execute -f scripts/create-sample-data.apex -u rishab_invoicedo@doinittechnologies.com.deved

String[] industries = new String[]{'HVAC', 'Healthcare', 'Legal', 'Dental', 'Auto', 'Retail'};
List<Survey_Template__c> templates = new List<Survey_Template__c>();

for (String industry : industries) {
    templates.add(new Survey_Template__c(
        Name = industry + ' Feedback Survey',
        Industry__c = industry
    ));
}

insert templates;

System.debug('Created ' + templates.size() + ' survey templates:');
for (Survey_Template__c t : templates) {
    System.debug('  - ' + t.Name + ' (Id: ' + t.Id + ') | Industry: ' + t.Industry__c);
}
