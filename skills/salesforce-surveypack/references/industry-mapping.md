# Salesforce Survey — Case Industry Mapping Reference

## How Case.Type Maps to Survey Template Industry

The `SurveyDistributionService` uses this mapping to find the right template when a Case closes:

| Case.Type Value | Maps To | Survey Template Industry |
|-----------------|---------|------------------------|
| `Mechanical` | → | Auto |
| `Electrical` | → | Auto |
| `Electronic` | → | Auto |
| `Structural` | → | Retail |
| `Other` | → | Retail |

## Extending the Mapping

To add your own mapping, modify `CASE_TYPE_TO_INDUSTRY` in `SurveyDistributionService.cls`:

```apex
private static final Map<String, String> CASE_TYPE_TO_INDUSTRY = new Map<String, String>{
    'Mechanical'   => 'Auto',
    'Electrical'  => 'Auto',
    'Electronic'  => 'Auto',
    'Structural'   => 'Retail',
    'Other'       => 'Retail'
    // Add your mappings here:
    // 'YourCaseType' => 'YourIndustry',
};
```

## Standard Salesforce Case Types

If your org uses different Case Type values, query them first:

```apex
Schema.DescribeFieldResult f = Schema.Case.Type.getDescribe();
List<Schema.PicklistEntry> entries = f.getPicklistValues();
for (Schema.PicklistEntry e : entries) {
    System.debug(e.getLabel() + ' (' + e.getValue() + ')');
}
```

## Alternative: Use Case.Industry Custom Field

If you have a custom `Industry__c` field on Case, update `distributeSurveyForCase()`:

```apex
@Future
public static void distributeSurveyForCase(Id caseId) {
    Case c = [SELECT Id, ContactId, Industry__c FROM Case WHERE Id = :caseId LIMIT 1];
    if (c.ContactId == null || String.isBlank(c.Industry__c)) return;
    
    Id templateId = getTemplateIdByIndustry(c.Industry__c);
    if (templateId == null) return;
    
    createSurveyResponse(templateId, c.ContactId);
}
```
