# SurveyPack Pro — Architecture

## Overview

SurveyPack Pro is a Salesforce-native managed package delivering pre-built NPS/CSAT/feedback survey templates by industry. All data stays within Salesforce — no external systems, zero compliance overhead.

---

## 📊 Data Model

### Object 1: `SurveyTemplate__c`
**Purpose:** Master record for each survey template (one per industry).

| Field | API Name | Type | Required | Notes |
|-------|----------|------|----------|-------|
| Template Name | `Name__c` | Text(255) | Yes | Display name |
| Industry | `Industry__c` | Picklist | Yes | HVAC, Legal, Healthcare, etc. |
| Description | `Description__c` | TextArea(1000) | No | Template description |
| Is Active | `Is_Active__c` | Checkbox | Yes | Default: false |
| Questions Count | `Questions_Count__c` | Number | No | Auto-count via formula |

### Object 2: `SurveyQuestion__c`
**Purpose:** Individual questions belonging to a template.

| Field | API Name | Type | Required | Notes |
|-------|----------|------|----------|-------|
| Template | `SurveyTemplate__c` | Lookup | Yes | To SurveyTemplate__c |
| Question Text | `Question_Text__c` | Text(500) | Yes | The actual question |
| Question Type | `Question_Type__c` | Picklist | Yes | NPS, CSAT, Text, MultipleChoice, Rating |
| Order | `Order__c` | Number(3) | Yes | Display order |
| Is Required | `Is_Required__c` | Checkbox | Yes | Default: false |
| Options | `Options__c` | TextArea(500) | No | JSON for MultipleChoice options |
| Scale Min | `Scale_Min__c` | Number | No | For Rating type |
| Scale Max | `Scale_Max__c` | Number | No | For Rating type |

### Object 3: `SurveyResponse__c`
**Purpose:** Captures each survey response instance.

| Field | API Name | Type | Required | Notes |
|-------|----------|------|----------|-------|
| Contact | `Contact__c` | Lookup | Yes | To Contact |
| Template | `SurveyTemplate__c` | Lookup | Yes | To SurveyTemplate__c |
| NPS Score | `NPS_Score__c` | Number(2,0) | No | 0–10 |
| CSAT Score | `CSAT_Score__c` | Number(2,0) | No | 1–5 |
| Response Date | `Response_Date__c` | DateTime | Yes | Auto-set on creation |
| Answers | `Answers__c` | LongTextArea(32000) | No | JSON blob of all answers |
| Status | `Status__c` | Picklist | Yes | Sent, Completed, Bounced, Opened |
| Case Reference | `Case__c` | Lookup | No | To Case (optional trigger context) |

### Object 4: `SurveyAnswer__c`
**Purpose:** Individual answer records (normalized, one per question).

| Field | API Name | Type | Required | Notes |
|-------|----------|------|----------|-------|
| Response | `SurveyResponse__c` | Lookup | Yes | To SurveyResponse__c |
| Question | `SurveyQuestion__c` | Lookup | Yes | To SurveyQuestion__c |
| Text Answer | `Text_Answer__c` | TextArea(2000) | No | For Text type |
| Number Answer | `Number_Answer__c` | Number | No | For NPS/Rating types |
| Selected Options | `Selected_Options__c` | TextArea(500) | No | JSON for MultipleChoice |

---

## 🔧 Apex Classes

### Controllers

| Class | Purpose |
|-------|---------|
| `SurveyTemplateController` | CRUD for templates, activation, question management |
| `SurveyResponseController` | Handle response submissions, score calculations |
| `SurveyDistributionService` | Trigger survey distribution via email or SF Actions |
| `SurveyScoreCalculator` | Compute NPS/CSAT from answers |

### Triggers

| Trigger | Object | Purpose |
|---------|--------|---------|
| `SurveyTemplateTrigger` | SurveyTemplate__c | Auto-set industry defaults on create |
| `SurveyResponseTrigger` | SurveyResponse__c | Update template response counts |

---

## ⚡ Salesforce Flows (1 per Industry)

Each flow follows the same pattern — different template lookup:

```
Trigger: Case Status = "Closed" AND Case Industry = <industry>
  → Lookup: Find SurveyTemplate__c where Industry__c = <industry> AND Is_Active__c = true
  → Decision: Template found?
    → YES: Insert SurveyResponse__c (Status = "Sent", link to Case Contact)
    → NO: Log warning
```

**Flows:**
1. `HVAC_Survey_Flow`
2. `Legal_Survey_Flow`
3. `Healthcare_Survey_Flow`
4. `RealEstate_Survey_Flow`
5. `Dental_Survey_Flow`
6. `AutoServices_Survey_Flow`

---

## 📧 Email Templates

One per industry: `Survey_<Industry>_Email_Template`
- Subject: "We'd love your feedback, {Contact.FirstName}!"
- Body: Links to survey (uses SF Actions or custom link to Visualforce/LWC survey page)
- Unsubscribe link included

---

## 📈 Reports & Dashboards

| Report | Purpose |
|--------|---------|
| NPS Score by Template | Rolling NPS per industry |
| Response Rate | Sent vs Completed per template |
| CSAT Average | Average CSAT per industry per month |
| Questions Breakdown | Per-question response aggregation |

**Dashboard:** "Survey Health" — combines all 4 reports with KPIs: Total Responses, Avg NPS, Avg CSAT, Response Rate %

---

## 🔐 Security & Sharing

- Objects: Private org-wide defaults (SurveyTemplate__c Read/Write, SurveyResponse__c Controlled by Parent)
- Field Level Security: Restrict NPS_Score__c to Survey Admins only on response objects
- Flows: System context (no sharing required)

---

## 🚢 Deployment

- **Current:** Dev org deploy via SFDX mdapi
- **Target:** Unlocked Package → Salesforce AppExchange
- **CI/CD:** GitHub Actions → Sandbox → Production

---

## 🔄 Sync Strategy (Org ↔ GitHub)

| Direction | Mechanism | Frequency |
|-----------|-----------|-----------|
| Org → GitHub | `sfdx force:source:retrieve` | Manual / On-demand |
| GitHub → Org | `sfdx force:source:deploy` | Manual / On-demand |
| Auto-sync | `scripts/sync.sh` cron job | Hourly |

GitHub is source of truth for all source (classes, flows, objects). Org is deployment target.
