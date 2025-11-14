---
issue_number: 272
title: "[Lecture Topic Task]: Conflict Detection and Resolution for Gamification Requirements"
state: "closed"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/272"
author: "Gabriel-Visbal"
labels: ["documentation","Team 3","Task: lecture-topic","state: concluded"]
created_at: "2025-11-09T13:29:15Z"
updated_at: "2025-11-10T17:41:00Z"
---

# [Lecture Topic Task]: Conflict Detection and Resolution for Gamification Requirements

- **Issue:** [272](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/272)
- **Author:** @Gabriel-Visbal
- **Labels:** ["documentation","Team 3","Task: lecture-topic","state: concluded"]
- **Created:** 2025-11-09T13:29:15Z

## Details
## 🎯 Objective
Apply Conflict Management principles from Chapter 3 (slides 6-14) to identify and resolve inconsistencies between competing requirements in the gamification system, specifically focusing on streak mechanics vs. user flexibility needs.

---

## 📝 Description
This task focuses on Inconsistency Management, particularly detecting and resolving conflicts between stakeholder viewpoints. According to slide 8, conflicts occur when requirements cannot be satisfied together, either as:

- Strong Conflicts: Logically inconsistent statements that can never both be true
- Weak Conflicts (Divergence): Requirements that conflict only under specific boundary conditions

In Pronunciation Coach, we have identified potential conflicts between:

1. Motivation requirements (strict daily streaks keep users engaged)
2. Flexibility requirements (users need forgiveness for missed days)
3. Progress requirements (XP should reflect actual effort)

Key Lecture Concepts Applied:

- Conflict detection using overlapping statements (slide 10)
- Conflict resolution tactics (slide 13)
- Systematic conflict management process (slides 10-14)

Why This Matters:
Our persons show conflicting needs: Maria (commuter) needs flexibility for unpredictable schedules, while David (dedicated learner) wants strict accountability. These viewpoints create requirement conflicts that must be resolved before implementation.

---

## ✅ Acceptance Criteria
Part 1: Conflict Detection (slides 10-11)
- [ ] Identify at least 3 pairs of conflicting requirements from existing documentation (Section 2.2)
- [ ] Classify each conflict as Strong or Weak with clear boundary conditions
- [ ] Document which personas or stakeholder viewpoints are in conflict
- [ ] Create an Interaction Matrix showing overlaps and conflicts between requirements

Part 2: Conflict Analysis (slide 8-9)
- [ ] For each weak conflict, clearly state the boundary condition that triggers the conflict
- [ ] Document the root cause (stakeholder objectives, non-functional trade-offs, etc.)
- [ ] Identify which requirements have the most conflicts (conflict count analysis)

Part 3: Resolution Generation (slide 12-13)
- [ ] Generate at least 2 alternative resolutions for each conflict using resolution tactics:
- Avoid boundary condition
- Restore conflicting statements
- Weaken conflicting statements
- Drop lower-priority statements
- Specialize conflict source or target
- [ ] Document trade-offs for each proposed resolution

Part 4: Resolution Selection (slide 14)
- [ ] Select preferred resolution for each conflict based on:
- Contribution to critical NFRs (user retention, engagement)
- Impact on other conflicts/risks
- [ ] Document rationale for each selection
- [ ] Update Section 2.2 with resolved requirements

---

## 🧪 Testing Plan
Validation with Persons
- Review each conflict with team to confirm it represents real stakeholder tension
- Map each conflict back to specific user stories from Section 2.2.1
- Verify boundary conditions are realistic (check with ESL students if possible)

Resolution Feasibility
- Confirm selected resolutions can be implemented within current architecture
- Verify resolutions don't create new conflicts
- Check if resolutions align with Section 2.2.4-2.2.5 interface/machine requirements

Documentation Completeness
- Ensure all conflicts are traceable to source requirements
- Verify interaction matrix correctly identifies overlaps
- Confirm new resolved requirements are added to Section 2.2

---

## ⏱️ Timeframe
Estimated completion time: 3-4 hours

---

## ⚡ Urgency
- [ ] Low  
- [X] Medium  
- [ ] High  

---

## 🎚️ Difficulty
- [ ] Easy  
- [X] Moderate  
- [ ] Hard  

---

## 👨‍💻 Recommended Assigned Developer
Suggested developer: @Gabriel-Visbal 
