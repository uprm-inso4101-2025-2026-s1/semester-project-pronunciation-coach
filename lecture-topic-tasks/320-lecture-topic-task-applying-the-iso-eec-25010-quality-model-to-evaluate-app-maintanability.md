---
issue_number: 320
title: "[Lecture Topic Task]: Applying the ISO/EEC 25010 Quality Model to Evaluate App Maintanability"
state: "open"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/320"
author: "pedroamorales"
labels: [
  "Task: lecture-topic",
  "state: concluded"
]
created_at: "2025-11-13T19:30:17Z"
updated_at: "2025-11-28T15:27:20Z"
---

# [Lecture Topic Task]: Applying the ISO/EEC 25010 Quality Model to Evaluate App Maintanability

- **Issue:** [320](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/320)
- **Author:** @pedroamorales
- **Labels:** [
  "Task: lecture-topic",
  "state: concluded"
]
- **Created:** 2025-11-13T19:30:17Z

## Details
## 🎯 Objective
Apply the ISO/IEC 25010 Quality Model to systematically evaluate and improve the maintainability of the Pronunciation Coach app.
The goal is to identify measurable quality attributes (e.g., modularity, reusability, analyzability, modifiability, and testability) and document strategies to sustain code quality and ease of future updates across Dart, Flutter, and Python modules.

---

## 📝 Description
The ISO/IEC 25010 standard defines eight primary quality characteristics, one of which is **maintainability**. This task focuses on evaluating how maintainable the current Pronunciation Coach architecture is, emphasizing:

- Code modularization between front-end (Flutter) and back-end (Python AI services)

- Consistency in naming conventions, documentation, and file organization
 
- Dependency management and version control practices
 
- Presence of test coverage and automation tools
 
- Traceability between requirements, code modules, and test cases

**Deliverables:**

- Maintainability Assessment Document (PDF)

- Map ISO/IEC 25010 maintainability sub-characteristics to existing code components.
 
- Assign a qualitative rating (High/Medium/Low) and justification for each.

- Maintainability Improvement Plan
 
- Recommend refactoring opportunities and documentation improvements.
 
- Code Metrics Report
 
- Use static analysis tools (e.g., Dart Analyze, pylint) to gather maintainability indices.
 
- Traceability Matrix

- Link maintainability concerns to corresponding requirements and architecture modules.

---

## 🧪 Testing Plan

1. **Static Analysis**

> - Run dart analyze and pylint on selected modules.
>  
> - Record warnings, errors, and complexity values.

 
2. **Code Review Sessions**
 

> - Peer review to validate adherence to coding standards and documentation.

  
3. **Maintainability Scoring**

> - Use a scoring rubric to quantify maintainability (e.g., 1–5 scale per sub-characteristic).

 
4. **Regression Simulation** 

> - Modify one module and evaluate how easily it can be updated without breaking dependencies.

---

## ⏱️ Timeframe
Estimated completion time: 3–4 days 

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
Suggested developer: @pedroamorales 

