---
issue_number: 173
title: "[Lecture Topic Task]: Add New Section 3.2.2 "Verification Plan for Quiz Feature" for Team 4"
state: "closed"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/173"
author: "iralys-sanchez18"
labels: ["documentation","Team 4","Task: lecture-topic","state: concluded"]
created_at: "2025-10-10T20:10:14Z"
updated_at: "2025-10-24T04:15:46Z"
---

# [Lecture Topic Task]: Add New Section 3.2.2 "Verification Plan for Quiz Feature" for Team 4

- **Issue:** [173](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/173)
- **Author:** @iralys-sanchez18
- **Labels:** ["documentation","Team 4","Task: lecture-topic","state: concluded"]
- **Created:** 2025-10-10T20:10:14Z

## Details
## 🎯 Objective
Expand section 3.2 “Validation and Verification” of Team 4’s documentation by adding a detailed verification plan that determines how the quiz feature will be tested and verified. This issue will be referenced by the lecture material on the topic, including lecture notes and PDFs (Phases of Software Engineering) which covered verification ("are we doing it right?") and the verbal expansion on validation ("are we doing the right thing?").

---

## 📝 Description
Our current documentation briefly mentions verification (“Unit Testing” and “Model-Checking”) but lacks a structured plan describing how the system will be verified in practice. This task expands that section by creating a verification plan specifically for the quiz feature under a new subsection 3.2.2 "Verification Plan for Quiz Feature.”

The verification plan will:

- Define verification goals and scope.
- Provide concrete test cases with inputs, steps, and expected results.
- Describe property-based and integration testing for randomness, timing, and error handling.
- Note performance and robustness checks (ex. response under network loss).

This new subsection will complement section 3.2.1 "Validation Scenarios" by focusing on technical correctness ("Are we doing it right?") rather than what the stakeholders want.

---

## ✅ Acceptance Criteria
- [x] New section "3.2.2 Verification Plan for Quiz Feature" is added to Team 4's documentation.
- [x] Verification techniques are consistent with the lecture’s "testing" phase (Triptych.pdf)
- [x] Property-based checks cover randomization rules (4 options, 1 correct, and no duplicates).
- [x] Integration and UI checks cover audio playback, mic permission, and feedback timing.
- [x] Edge cases and negative tests (invalid input, duplicates, OOV words, network loss) are included.
- [x] Performance verification (question generation and feedback <= 2-3 seconds) is noted.

---

## 🧪 Testing Plan
- Use property tests for randomization rules; integration/UI tests for audio playback, mic permissions, and pronunciation feedback; and negative tests for invalid inputs, duplicates, and network issues.
- Run tests locally and in CI.
- Ensure each test follows clear pass/fail criteria.
- Ensure the plan logically complements 3.2.1 "Validation Scenarios".

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
- [x] Moderate  
- [ ] Hard  

---

## 👨‍💻 Recommended Assigned Developer
Suggested developer: _@iralys-sanchez18_  
