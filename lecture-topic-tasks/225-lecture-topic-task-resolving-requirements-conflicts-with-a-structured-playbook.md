---
issue_number: 225
title: "[Lecture Topic Task]: Resolving Requirements Conflicts with a Structured Playbook"
state: "closed"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/225"
author: "aryamdiaz"
labels: ["Team 1","Task: lecture-topic","state: concluded"]
created_at: "2025-10-23T16:51:52Z"
updated_at: "2025-10-24T04:12:15Z"
---

# [Lecture Topic Task]: Resolving Requirements Conflicts with a Structured Playbook

- **Issue:** [225](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/225)
- **Author:** @aryamdiaz
- **Labels:** ["Team 1","Task: lecture-topic","state: concluded"]
- **Created:** 2025-10-23T16:51:52Z

## Details
## 🎯 Objective
Establish and apply a repeatable method to detect, classify, and resolve requirements conflicts, and produce the Lecture Topic Task.

---

## 📝 Description
I’ve observed ambiguous and conflicting statements in the spec (e.g., mixed meanings of User, time windows expressed as points vs. intervals). In this task I will introduce a 5-step conflict workflow (overlaps → detect → document → generate → select) plus a propagation note, and compile the content into a polished PDF.

Scope (initial pass)
- Target features: Login, Quiz attempts, Feedback/Results.
- Conflict types to consider: terminology, designation, structure; weak vs. strong.

References: my class notes/slides for Requirements Evaluation and Design.

---

## ✅ Acceptance Criteria

- A Conflict Log exists in the repo (e.g., docs/conflicts/CONFLICT_LOG.md) with at least 3 entries (CF-IDs).
- Each entry includes: statements, clash type, strength, boundary (for weak), ≥3 candidate resolutions, decision & rationale, impacted artifacts, verification.
-  The Glossary is updated with new/clarified terms (e.g., StudentUser, StaffUser, SessionDuration).
- At least 1 requirement is rewritten to remove a conflict (before/after shown in the PR).
- Verification hooks are added (at least one unit/widget test or manual step linked in the PR).
- A mini slide deck (10–12 min) is committed under docs/lectures/ with agenda + examples.

---

## 🧪 Testing Plan

- Review checklist: In the PR, I’ll verify each CF-ID entry contains all required fields.
- Unit/Widget tests:
  - RB-READONLY-STUDENT (student cannot edit rubric).
  - RA-EDIT-STAFF (staff can edit rubric).
  - Boundary test for the feedback window (e.g., 15 minutes after submission).
- Manual walkthrough: I’ll simulate the accommodation path and confirm the policy-based weakening is respected.
- CI checks: Markdown links are valid; glossary terms are cross-referenced.

---

## ⏱️ Timeframe
Estimated completion time: 1-2 days

---

## ⚡ Urgency
- [ ] Low  
- [ ] Medium  
- [ ] High  

---

## 🎚️ Difficulty
- [ ] Easy  
- [ ] Moderate  
- [ ] Hard  

---

## 👨‍💻 Recommended Assigned Developer
Suggested developer: @aryamdiaz 
