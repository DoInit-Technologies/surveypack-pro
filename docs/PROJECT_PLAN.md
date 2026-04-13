# SurveyPack Pro — Project Plan

## 📋 Overview

**Project:** SurveyPack Pro
**Goal:** Ship a Salesforce-native survey template app — install in minutes, auto-triggers on Salesforce events
**Sprint:** 30-day sprint (100K in 30 Days), started April 10, 2026
**Dev Org:** https://orgfarm-f0ed39956a-dev-ed.develop.my.salesforce.com

---

## 🎯 Milestones

| Milestone | Target | Deliverable |
|-----------|--------|-------------|
| M1: Core Data Model | Day 1 | All custom objects + fields deployed to dev org |
| M2: MVP Templates | Day 3 | 6 industry templates active with sample questions |
| M3: Flow Triggers | Day 5 | 6 Salesforce Flows (one per industry) deployed |
| M4: Apex Controllers | Day 7 | All Apex classes + triggers deployed |
| M5: Email Templates | Day 9 | Email templates per industry |
| M6: Reports & Dashboards | Day 10 | Pre-built reports + dashboard |
| M7: Full Deploy | Day 12 | Complete app deployed to dev org, tested end-to-end |
| M8: Package Prep | Day 14 | Unlocked package ready for AppExchange |

---

## 📅 Sprint Breakdown

### Sprint 1: Foundation (Days 1–7)
**Goal:** Core data model + sample templates

| Day | Task | Owner |
|-----|------|-------|
| 1 | Deploy SurveyTemplate__c, SurveyQuestion__c, SurveyResponse__c, SurveyAnswer__c objects | Dev |
| 1 | Create field validation rules | Dev |
| 2 | Create Apex triggers for each object | Dev |
| 3 | Build SurveyTemplateController + SurveyResponseController | Dev |
| 4 | Create 6 sample SurveyTemplate__c records (one per industry) | Dev |
| 5 | Create sample SurveyQuestion__c records (5 questions per template) | Dev |
| 6 | Code review + object cleanup | Dev |
| 7 | **SPRINT GATE:** All objects, controllers, triggers deployed + tested | Dev + QA |

### Sprint 2: Automation (Days 8–14)
**Goal:** Flow triggers + email distribution

| Day | Task | Owner |
|-----|------|-------|
| 8 | Build HVAC_Survey_Flow | Dev |
| 9 | Build Legal, Healthcare, RealEstate flows | Dev |
| 10 | Build Dental, AutoServices flows | Dev |
| 11 | Build SurveyDistributionService (Apex email handler) | Dev |
| 12 | Create email templates per industry (6 templates) | Dev |
| 13 | End-to-end test: trigger flow → send email → capture response | Dev + QA |
| 14 | **SPRINT GATE:** All flows + emails working end-to-end | Dev + QA |

### Sprint 3: Reporting + Polish (Days 15–21)
**Goal:** Reports, dashboards, UX polish

| Day | Task | Owner |
|-----|------|-------|
| 15 | Build NPS Score by Template report | Dev |
| 16 | Build Response Rate + CSAT Average reports | Dev |
| 17 | Build Survey Health dashboard | Dev |
| 18 | Build questions breakdown report | Dev |
| 19 | Page layout refinements | Dev |
| 20 | Security review (FLS, sharing) | Dev |
| 21 | **SPRINT GATE:** Reports + dashboard live | Dev + QA |

### Sprint 4: Package + Launch (Days 22–30)
**Goal:** Unlocked package + installable product

| Day | Task | Owner |
|-----|------|-------|
| 22 | Create unlocked package (v1.0.0) | Dev |
| 23 | Test package install in fresh org | Dev |
| 24 | Write install documentation | PM |
| 25 | Write README + marketing blurb | Blog |
| 26 | Publish to GitHub releases | Dev |
| 27 | AppExchange listing prep | PM |
| 28 | Soft launch (post to Twitter, LinkedIn) | Blog |
| 29 | Gather feedback + bug fixes | Dev |
| 30 | **FINAL GATE:** v1.0.0 live, first users onboarded | All |

---

## ✅ Definition of Done

Each component must meet:
- [ ] Metadata deployed to dev org via SFDX
- [ ] Zero deployment errors
- [ ] Apex tests pass (if applicable)
- [ ] Manual smoke test in UI confirmed
- [ ] Added to GitHub repo under `force-app/main/default/`

---

## ⚠️ Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| SFDX deploy failures (metadata errors) | Medium | Low | Use mdapi format, validate XML before deploy |
| Flow trigger complexity | High | Medium | Start with simplest trigger (Case Close), replicate pattern |
| Email deliverability issues | Low | Medium | Use SF default email, avoid spam triggers |
| AppExchange approval delays | High | Low | Build to open-source first, AppExchange later |

---

## 📊 Success Metrics

| Metric | Target |
|--------|--------|
| Objects deployed | 4/4 |
| Apex classes | 4+ |
| Flows | 6/6 |
| Email templates | 6/6 |
| Reports | 4/4 |
| Dashboard | 1/1 |
| Unlocked package | 1 |

---

## 🛠️ Tech Stack

- **Platform:** Salesforce (dev org)
- **CLI:** SFDX
- **Source Control:** GitHub (DoInit-Technologies/surveypack-pro)
- **Deployment:** mdapi zip → sfdx force:mdapi:deploy
- **Language:** Apex + Salesforce Flow + XML metadata

---

*Plan created by: PM Agent | Date: April 13, 2026*
