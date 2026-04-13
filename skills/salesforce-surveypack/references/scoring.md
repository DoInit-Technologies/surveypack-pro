# NPS & CSAT Score Calculation Reference

## NPS (Net Promoter Score)

### Definition
- **Range:** 0–10
- **Promoters:** 9–10 — loyal enthusiasts who will keep buying and refer others
- **Passives:** 7–8 — satisfied but not enthusiastic, vulnerable to competition
- **Detractors:** 0–6 — unhappy customers who can damage your brand

### Formula
```
NPS = (Promoters - Detractors) / Total Responses × 100
```

Result range: **-100 to +100**

### Example
100 responses: 50 promoters (9-10), 30 passives (7-8), 20 detractors (0-6)
```
NPS = (50 - 20) / 100 × 100 = +30
```

### Apex Implementation
```apex
public static Decimal calculateNPS(List<Integer> scores) {
    if (scores == null || scores.isEmpty()) return null;
    Integer promoters = 0;
    Integer detractors = 0;
    for (Integer score : scores) {
        if (score >= 9) promoters++;
        else if (score <= 6) detractors++;
    }
    return ((promoters - detractors) / Decimal.valueOf(scores.size())) * 100;
}
```

## CSAT (Customer Satisfaction Score)

### Definition
- **Range:** 1–5 (most common) or 1–10
- 1 = Very Dissatisfied
- 2 = Dissatisfied
- 3 = Neutral
- 4 = Satisfied
- 5 = Very Satisfied

### Formula
```
CSAT = SUM(scores) / COUNT(responses)
```
Result range: **1 to 5** (or normalized to 0–100%)

### CSAT as Percentage
```
CSAT % = ((Average Score - 1) / (Max - 1)) × 100
```
For 1–5 scale with avg 4.2:
```
CSAT % = (4.2 - 1) / (5 - 1) × 100 = 80%
```

## Typical Benchmarks

| NPS Score | Interpretation |
|----------|----------------|
| +70 to +100 | Excellent — world-class |
| +50 to +69 | Good — competitive |
| +30 to +49 | Average — room to improve |
| 0 to +29 | Poor — needs attention |
| -100 to 0 | Bad — serious problem |

| CSAT Score | Interpretation |
|-----------|---------------|
| 4.5–5.0 | Excellent |
| 4.0–4.4 | Good |
| 3.5–3.9 | Average |
| 3.0–3.4 | Poor |
| 1.0–2.9 | Bad |

## SOQL Aggregations for Reporting

```apex
// Get NPS stats by template
SELECT Survey_Template__r.Name,
       COUNT(Id) totalResponses,
       AVG(NPS_Score__c) avgNPS,
       SUM(CASE WHEN NPS_Score__c >= 9 THEN 1 ELSE 0 END) promoters,
       SUM(CASE WHEN NPS_Score__c <= 6 THEN 1 ELSE 0 END) detractors
FROM Survey_Response__c
WHERE Status__c = 'Completed' AND NPS_Score__c != null
GROUP BY Survey_Template__r.Name

// Get CSAT stats by template
SELECT Survey_Template__r.Name,
       AVG(CSAT_Score__c) avgCSAT,
       COUNT(Id) totalResponses
FROM Survey_Response__c
WHERE Status__c = 'Completed' AND CSAT_Score__c != null
GROUP BY Survey_Template__r.Name

// Response rate
SELECT Survey_Template__r.Name,
       SUM(CASE WHEN Status__c = 'Sent' THEN 1 ELSE 0 END) sent,
       SUM(CASE WHEN Status__c = 'Completed' THEN 1 ELSE 0 END) completed
FROM Survey_Response__c
GROUP BY Survey_Template__r.Name
```
