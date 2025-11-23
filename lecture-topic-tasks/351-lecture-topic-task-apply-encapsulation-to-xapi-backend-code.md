---
issue_number: 351
title: "[Lecture Topic Task]:  <Apply Encapsulation to xAPI Backend code>"
state: "open"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/351"
author: "ivxnmorxles"
labels: [
  "Team 3",
  "Task: lecture-topic",
  "task: development",
  "state: waiting for team lead"
]
created_at: "2025-11-22T18:40:30Z"
updated_at: "2025-11-23T17:12:55Z"
---

# [Lecture Topic Task]:  <Apply Encapsulation to xAPI Backend code>

- **Issue:** [351](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/351)
- **Author:** @ivxnmorxles
- **Labels:** [
  "Team 3",
  "Task: lecture-topic",
  "task: development",
  "state: waiting for team lead"
]
- **Created:** 2025-11-22T18:40:30Z

## Details
## 🎯 Objective
Encapsulate xAPI functionality behind a clear abstraction layer so UI code only depends on high-level operations, not low-level HTTP or JSON details.

---

## 📝 Description
The current xAPI implementation is split across xapi_client.dart, xapi_helpers.dart, and xapi_provider.dart, but we want this structure to follow the design principle of encapsulation and levels of abstraction  discussed in lecture software-design.

This issue focuses on :
- xapi_client.dart is the low-level HTTP client that knows how to talk to the backend.
- xapi_helpers.dart contains pure helper functions that know what an xAPI statement looks like.
- xapi_provider.dart is the high-level API used by widgets, exposing clear methods, so UI code does not deal with raw JSON, URLs, or headers.
 
No new features are added, the goal is to align the existing xAPI code with the course’s software design principles.

---

## ✅ Acceptance Criteria
List the conditions that must be met for this issue to be considered complete.  
- [x] xapi_client.dart only exposes a small public API and hides HTTP details
- [x] xapi_helpers.dart contains pure functions to build xAPI statements and does not perform any network calls. 
- [x] xapi_helpers.dart contains pure functions to build xAPI statements and does not perform any network calls.

---

## 🧪 Testing Plan
- Ensure code still follows and completes previous features. 
- Confirm that refactor does not break existing flows that send xAPI statements.

---

## ⏱️ Timeframe
Estimated completion time: 1 day 

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
Suggested developer: @ivxnmorxles  

