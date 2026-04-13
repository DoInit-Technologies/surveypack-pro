# SurveyPack Pro — Salesforce Skill

A MiniMax Agent skill for creating, managing, and analyzing NPS/CSAT feedback surveys in Salesforce.

## What This Skill Does

1. **Creates survey templates** per industry (HVAC, Legal, Healthcare, Real Estate, Dental, Auto Services, etc.)
2. **Distributes surveys** automatically when Salesforce Cases close (via Apex trigger)
3. **Tracks responses** (NPS 0-10, CSAT 1-5, text feedback, status: Sent/Opened/Completed/Bounced)
4. **Builds reports** — NPS by template, response rate, CSAT average by industry

## Files

```
salesforce-surveypack/
├── SKILL.md                    # Main skill definition
├── references/
│   ├── industry-mapping.md    # Case.Type → Survey Industry mapping
│   └── scoring.md            # NPS & CSAT calculation formulas + SOQL
└── scripts/
    └── create-sample-data.apex  # Creates 6 industry templates
```

## Quick Start

1. Deploy to your Salesforce org via SFDX
2. Run the sample data script to create 6 industry templates
3. Activate the templates you want to use
4. Close a Case — the trigger auto-creates a survey response

## Publishing to MiniMax Marketplace

To publish this as a MiniMax skill:
1. Fork or create a repo on GitHub
2. Push this `salesforce-surveypack/` directory
3. Submit to the MiniMax Agent Remix Marketplace
4. Earn 100 Credits for every Remix

## Deployed Components

- `Survey_Template__c` custom object (Name, Industry__c, Is_Active__c)
- `Survey_Response__c` custom object (NPS_Score__c, CSAT_Score__c, Free_Text_Feedback__c, Status__c)
- `SurveyTemplateController.cls` — Template CRUD
- `SurveyResponseController.cls` — Response handling + Flow invocable
- `SurveyDistributionService.cls` — Distribution logic + industry mapping
- `CaseTrigger.trigger` — Auto-fires on Case close
