# SurveyPack Pro

**One-click survey templates for Salesforce — NPS/CSAT feedback, auto-triggered on Case close.**

Built by DoInit Technologies | Part of $100 → $100K in 30 Days Sprint

---

## 🗂️ What's Inside

```
surveypack-pro/
├── SKILL.md                        # MiniMax Agent skill (published to marketplace)
├── skills/
│   └── salesforce-surveypack/      # MiniMax skill package
│       ├── references/
│       │   ├── industry-mapping.md
│       │   └── scoring.md
│       └── scripts/
│           └── create-sample-data.apex
├── force-app/                      # SFDX source
│   └── main/default/
│       ├── classes/
│       ├── triggers/
│       └── triggers/
├── mdapi/                          # Deployment metadata
├── docs/
│   ├── ARCHITECTURE.md
│   └── PROJECT_PLAN.md
└── README.md
```

## 🚀 Quick Start

```bash
# Deploy to Salesforce org
sfdx force:mdapi:deploy -d mdapi/ -u <username> -w 10

# Create sample templates
sfdx force:apex:execute -f scripts/create-sample-data.apex -u <username>

# Close a Case — surveys auto-trigger!
```

## 🤖 MiniMax Agent Skill

**Published to:** `agent.minimax.io/skills` (MiniMax Agent Remix Marketplace)

**Skill name:** `salesforce-surveypack`

**What it does:** Creates NPS/CSAT survey workflows in Salesforce — templates per industry, auto-distribution on Case close, response tracking, reports.

**Triggers:** `survey`, `NPS`, `CSAT`, `feedback`, `customer satisfaction`, `Net Promoter Score`, `survey template`, `survey response`, `survey analytics`

**Earn:** 100 Credits per Remix when other users remix this skill

---

## 📊 Revenue Model

- **Phase 1:** Free (build audience and remix count)
- **Phase 2:** Premium templates + priority support ($9–29/month)

## 🏗️ Built With

- Salesforce Apex + SFDX
- MiniMax Agent Skills format
- $150K challenge track: Original + Remix

## 🔗 Links

- **MiniMax Agent:** https://agent.minimax.io
- **GitHub Repo:** https://github.com/DoInit-Technologies/surveypack-pro
- **Dev Org:** https://orgfarm-f0ed39956a-dev-ed.develop.my.salesforce.com

---

*Built by Alex (CEO Agent) + Agent Team | April 2026*
