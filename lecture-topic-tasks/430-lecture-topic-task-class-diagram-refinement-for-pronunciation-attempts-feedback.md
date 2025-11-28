---
issue_number: 430
title: "[Lecture Topic Task]: <Class Diagram Refinement for Pronunciation Attempts & Feedback>"
state: "open"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/430"
author: "Fernando18Torres"
labels: [
  "Task: lecture-topic"
]
created_at: "2025-11-28T19:14:08Z"
updated_at: "2025-11-28T22:45:14Z"
---

# [Lecture Topic Task]: <Class Diagram Refinement for Pronunciation Attempts & Feedback>

- **Issue:** [430](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/430)
- **Author:** @Fernando18Torres
- **Labels:** [
  "Task: lecture-topic"
]
- **Created:** 2025-11-28T19:14:08Z

## Details
## 🎯 Objective
Apply the *Class Diagrams* lecture to refine the design of the "Pronunciation Attempts & Feedback" part of the Pronunciation Coach App. The goal is to clearly model the main classes involved when a user practices a phrase and receives feedback, showing attributes, associations, and multiplicities.

---

## 📝 Description
In class we saw how class diagrams help capture the static structure of a system: classes, attributes, relationships, responsibilities, and multiplicities.

For this task I will:
- Identify the main classes involved in a pronunciation attempt (e.g., UserProfile, PracticeSession, Attempt, Phrase, FeedbackEngine, FeedbackResult).
- Design or refine a UML class diagram for this subset of the system.
- Make sure the diagram follows lecture conventions (visibility, associations, aggregation/composition where appropriate, and multiplicities).
- Add the diagram to the project documentation.

The diagram will be stored in the repo under `docs/diagrams/` and referenced from the main documentation.

---

## ✅ Acceptance Criteria
- [ ] A UML class diagram is created/updated for the "Pronunciation Attempts & Feedback" subdomain.
- [ ] Diagram includes at least the following classes (or equivalent names): `UserProfile`, `PracticeSession`, `Attempt`, `Phrase`, `FeedbackEngine`, `FeedbackResult`.
- [ ] Relationships and multiplicities are specified (e.g. one `PracticeSession` has many `Attempt`s).
- [ ] The diagram is saved as `docs/diagrams/pronunciation-attempts-class-diagram.png` (or .svg).
- [ ] The main documentation references and briefly explains this diagram.
- [ ] This issue includes a link to the commit SHA where the diagram and doc changes were added.

---

## 🧪 Testing Plan
- Manually review the diagram against the current implementation and planned features.
- Check that all key concepts used in the code or docs are represented by classes in the diagram or are intentionally left out.
- Peer self-review: verify that the diagram respects the notation and best practices from the class slides on class diagrams.

---

## ⏱️ Timeframe
Estimated completion time: 1–2 days.

---

## ⚡ Urgency
- [x] Low  
- [ ] Medium  
- [ ] High  

---

## 🎚️ Difficulty
- [x] Easy  
- [ ] Moderate  
- [ ] Hard  

---

## 👨‍💻 Recommended Assigned Developer
Suggested developer: @Fernando18Torres

