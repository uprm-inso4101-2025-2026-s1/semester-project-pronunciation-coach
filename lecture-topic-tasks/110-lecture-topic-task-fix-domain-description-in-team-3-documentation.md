---
issue_number: 110
title: "[Lecture Topic Task]: Fix Domain Description in Team 3 Documentation"
state: "closed"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/110"
author: "amtrevisan"
labels: ["documentation","Team 3","Task: lecture-topic","state: concluded"]
created_at: "2025-09-29T21:10:20Z"
updated_at: "2025-10-07T17:45:49Z"
---

# [Lecture Topic Task]: Fix Domain Description in Team 3 Documentation

- **Issue:** [110](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/110)
- **Author:** @amtrevisan
- **Labels:** ["documentation","Team 3","Task: lecture-topic","state: concluded"]
- **Created:** 2025-09-29T21:10:20Z

## Details
## 🎯 Objective
Revise Section 2.1 of Team 3 documentation to follow Triptych lecture principles - domain should describe "as-is" situation only, with no references to "the system."

---

## 📝 Description
**Lecture Connection:** Applies "Phases of Software Engineering" Triptych lecture - specifically the Domain Description phase which must describe the current situation without referencing the system-to-be.

### What to Fix:
Our current Section 2.1.5 (Domain Functions) describes what "the system" does instead of what happens in the domain naturally. According to the lecture, domain functions should describe domain operations, not system operations.

**Example of what's wrong:**
```
assessPronunciation : PronunciationAttempt × PronunciationModel → AccuracyScore
Description: Compares learner's pronunciation attempt against native speaker model...
```

This describes a system function. It should describe what happens in the domain (like a tutor evaluating a student).

### What to Do:
1. Rewrite Section 2.1.5 - change functions to describe domain activities (tutors, learners, practice sessions) not system operations
2. Add Section 2.1.7 - document one pronunciation practice behavior as a sequence of events and actions
3. Remove any "the system" references from all of Section 2.1

---

## ✅ Acceptance Criteria
- [ ] Section 2.1.5 rewritten with domain functions (no "system" references)
- [ ] New Section 2.1.7 added with at least one behavior sequence
- [ ] Zero instances of "the system" in Section 2.1.1 through 2.1.7
- [ ] All changes highlighted in yellow in the document
- [ ] Includes note citing Triptych lecture at end of Section 2.1

---

## 🧪 Testing Plan
- Search document for "the system" in Section 2.1 - should find zero
- Have peer review to catch any system-to-be references
- Manager verifies clear separation from Section 2.2 (Requirements)

---

## ⏱️ Timeframe
Estimated completion time: 3 days

---

## ⚡ Urgency
- [ ] Low  
- [x] Medium  
- [ ] High  

---

## 🎚️ Difficulty
- [ ] Easy  
- [X] Moderate  
- [ ] Hard  

---

## 👨‍💻 Recommended Assigned Developer
Suggested developer: @AlexMoralesDev 
