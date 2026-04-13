---
name: salesforce-surveypack
description: "Pre-built NPS/CSAT/feedback survey templates for Salesforce. Use when the user needs to create, manage, send, or analyze customer feedback surveys in Salesforce — including auto-triggered surveys on case close, contract signing, or appointment completion. Covers: creating survey templates per industry (HVAC, Legal, Healthcare, Real Estate, Dental, Auto Services), managing survey responses (NPS/CSAT scores), building response reports/dashboards, and distributing surveys via email or Salesforce Flow. Triggers on: 'survey', 'NPS', 'CSAT', 'feedback', 'customer satisfaction', 'Net Promoter Score', 'CSAT score', 'send survey', 'survey template', 'survey response', 'survey analytics', 'CSI', 'CX', 'voice of customer', 'VOC'."
license: MIT
metadata:
  version: "1.0"
  category: productivity
  sources:
    - https://developer.salesforce.com/docs/atlas.en-us/api/sforce_api_objects_survey.vm
    - https://developer.salesforce.com/docs/atlas.en-us/api/sforce_api_objects_surveyresponse.vm
    - https://developer.salesforce.com/docs/atlas.en-us/sfdc/pdf/salesforce_apex_reference.pdf
    - https://developer.salesforce.com/docs/atlas.en-us/workbook_vfx/workbook_vfx.pdf
---

# SurveyPack Pro — Salesforce Survey Templates

Handle survey creation, distribution, response tracking, and analytics for Salesforce orgs. Works with SurveyPack Pro managed package or custom survey objects.

## When to Use This Skill

- User wants to **create or manage survey templates** in Salesforce
- User wants to **send NPS/CSAT surveys** automatically on Salesforce events
- User wants to **track and analyze survey responses** (NPS, CSAT, text feedback)
- User wants to **build reports/dashboards** on survey performance
- User mentions: NPS, CSAT, customer feedback, survey, Net Promoter Score, CSAT score, survey analytics, CSI, CX, voice of customer, VOC
- User has SurveyPack Pro installed or has custom survey objects

## Core Objects (SurveyPack Pro)

| Object | API Name | Purpose |
|--------|----------|---------|
| Survey Template | `Survey_Template__c` | Master record per industry — name, industry, active flag |
| Survey Response | `Survey_Response__c` | Each survey instance — contact, template, NPS, CSAT, status, feedback |
| Survey Question | `Survey_Question__c` | Individual questions per template (optional — can use JSON) |

### Survey_Template__c Fields
- `Name` — Template display name
- `Industry__c` — Picklist: HVAC, Healthcare, Legal, Dental, Auto, Retail
- `Is_Active__c` — Boolean
- `Questions_JSON__c` — JSON blob of questions (alternative to Survey_Question__c)

### Survey_Response__c Fields
- `Contact__c` — Lookup to Contact
- `Survey_Template__c` — Lookup to Survey_Template__c
- `NPS_Score__c` — Number (0–10)
- `CSAT_Score__c` — Number (1–5)
- `Free_Text_Feedback__c` — Long Text Area
- `Status__c` — Picklist: Sent, Opened, Completed, Bounced
- `Response_Date__c` — DateTime

## Survey Distribution — Apex Trigger Approach

Instead of Salesforce Flow, use **Apex triggers** for reliable, code-controlled survey distribution:

### Case Close Trigger Logic
```apex
trigger CaseTrigger on Case (after update) {
    for (Integer i = 0; i < Trigger.new.size(); i++) {
        Case c = Trigger.new[i];
        Case old = Trigger.old[i];
        if (c.Status == 'Closed' && old.Status != 'Closed') {
            SurveyDistributionService.distributeSurveyForCase(c.Id);
        }
    }
}
```

### Industry Mapping (Case.Type → Survey Industry)
| Case.Type | Survey Industry |
|---------|----------------|
| Mechanical | Auto |
| Electrical | Auto |
| Electronic | Auto |
| Structural | Retail |
| Other | Retail |
| (custom) | Map to match your industry values |

### SurveyDistributionService Methods
```apex
// Get active template ID for an industry
Id templateId = SurveyDistributionService.getTemplateIdByIndustry('HVAC');

// Create pending survey response
Id respId = SurveyDistributionService.createSurveyResponse(templateId, contactId);

// Full distribution (create + debug log)
Id respId = SurveyDistributionService.distributeSurvey(templateId, contactId);
```

## Survey Distribution — Flow Approach (Alternative)

If Flow is preferred, create a **Record-Triggered Flow** on Case:

1. **Trigger:** When a Case record is Updated and Status = 'Closed'
2. **Get Records:** Find Survey_Template__c where Industry__c matches Case.Industry AND Is_Active__c = true
3. **Decision:** Template found?
4. **Create Records:** Insert Survey_Response__c with Contact__c, Survey_Template__c, Status__c = 'Sent'

Then use `SurveyResponseController.createResponseFromFlow()` as an Apex Action.

## SurveyResponseController (Apex Class)

```apex
// Submit a completed response
Survey_Response__c resp = SurveyResponseController.submitResponse(
    templateId,       // Survey_Template__c ID
    contactId,         // Contact ID
    npsScore,         // Decimal (0-10)
    csatScore,        // Decimal (1-5)
    textFeedback      // String
);

// Get all responses for a contact
List<Survey_Response__c> responses = SurveyResponseController.getResponsesForContact(contactId);

// Create response from Flow (invocable)
SurveyResponseController.createResponseFromFlow(new List<Id>{templateId}, new List<Id>{contactId});
```

## SurveyTemplateController (Apex Class)

```apex
// Get all templates
List<Survey_Template__c> templates = SurveyTemplateController.getAllTemplates();

// Get templates by industry
List<Survey_Template__c> templates = SurveyTemplateController.getTemplatesByIndustry('HVAC');

// Get active template ID
Id templateId = SurveyTemplateController.getTemplateIdByIndustry('HVAC');
```

## NPS & CSAT Score Calculations

### NPS (Net Promoter Score)
- Score: **0–10**
- **Promoters:** 9–10
- **Passives:** 7–8
- **Detractors:** 0–6
- Formula: `(Promoters - Detractors) / Total * 100`

### CSAT (Customer Satisfaction)
- Score: **1–5**
- Usually "How satisfied were you?" with 1=Very Dissatisfied, 5=Very Satisfied
- Average CSAT = SUM(scores) / COUNT(responses)

### Example SOQL Aggregation
```apex
List<AggregateResult> results = [
    SELECT Status__c, COUNT(Id) cnt, AVG(NPS_Score__c) avgNPS, AVG(CSAT_Score__c) avgCSAT
    FROM Survey_Response__c
    WHERE Survey_Template__c = :templateId
    GROUP BY Status__c
];
```

## Sample Data Creation (Apex)

```apex
// Create 6 industry templates
String[] industries = new String[]{'HVAC', 'Healthcare', 'Legal', 'Dental', 'Auto', 'Retail'};
List<Survey_Template__c> templates = new List<Survey_Template__c>();
for (String industry : industries) {
    templates.add(new Survey_Template__c(
        Name = industry + ' Feedback Survey',
        Industry__c = industry
    ));
}
insert templates;
```

## Reports & Dashboards to Build

### Report 1: NPS Score by Template
- **Object:** Survey_Response__c
- **Columns:** Template Name, NPS Score, Status, Response Date
- **Filter:** Status = 'Completed'
- **Grouping:** Survey_Template__c.Name

### Report 2: Response Rate
- **Formula:** Completed / Sent * 100
- **Columns:** Template Name, Total Sent, Total Completed, Rate %

### Report 3: CSAT Average by Industry
- **Object:** Survey_Response__c
- **Aggregation:** AVG(CSAT_Score__c) GROUP BY Survey_Template__r.Industry__c

## Email Survey Template Structure

One email template per industry. Structure:

```
Subject: We value your feedback, {Contact.FirstName}!

Body:
Hi {Contact.FirstName},

Your feedback helps us improve. It takes 2 minutes.

{[NPS Question]}
{[CSAT Question]}
{[Open Text Question]}

Click here to complete the survey: {SurveyLink}

Thanks,
{Company.Name}
```

## Deployment (SFDX)

```bash
# Deploy to org
sfdx force:mdapi:deploy -d mdapi/ -u <username> -w 10

# Retrieve from org
sfdx force:source:retrieve -m ApexClass,CustomObject,Flow -u <username>

# Run sample data script
sfdx force:apex:execute -f scripts/create-sample-data.apex -u <username>
```

## Key Files

| File | Purpose |
|------|---------|
| `scripts/create-sample-data.apex` | Creates 6 industry templates |
| `classes/SurveyTemplateController.cls` | Template CRUD operations |
| `classes/SurveyResponseController.cls` | Response handling + Flow invocable |
| `classes/SurveyDistributionService.cls` | Distribution logic + industry mapping |
| `classes/CaseTrigger.trigger` | Auto-fires on Case close |
| `mdapi/package.xml` | Deployment manifest |
