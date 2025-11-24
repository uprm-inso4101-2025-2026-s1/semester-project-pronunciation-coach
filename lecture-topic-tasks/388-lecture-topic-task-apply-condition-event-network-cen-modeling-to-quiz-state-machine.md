---
issue_number: 388
title: "[Lecture Topic Task]: Apply Condition Event Network (CEN) Modeling to Quiz State Machine"
state: "open"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/388"
author: "amtrevisan"
labels: [
  "Team 3",
  "Task: lecture-topic",
  "state: waiting for manager"
]
created_at: "2025-11-23T21:12:35Z"
updated_at: "2025-11-24T00:13:51Z"
---

# [Lecture Topic Task]: Apply Condition Event Network (CEN) Modeling to Quiz State Machine

- **Issue:** [388](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/388)
- **Author:** @amtrevisan
- **Labels:** [
  "Team 3",
  "Task: lecture-topic",
  "state: waiting for manager"
]
- **Created:** 2025-11-23T21:12:35Z

## Details
## 🎯 Objective
Extend the quiz state machine (issue #303) using Condition Event Network (CEN) concepts to replace simple transitions with pre/post condition markings for improved concurrency and runtime validation.

---

## 📝 Description
Integrate CEN modeling into the existing statechart-based quiz flow. Represent states as places with markings and events as transitions fired when preconditions are satisfied. Add marking logic for sequential quiz progression and set the foundation for future concurrent features such as offline sync validation.

---

## ✅ Acceptance Criteria
- [ ] Place class with marking and unmarking  
- [ ] Transition class with pre/post condition checks  
- [ ] CEN layer integrated with the current statechart FSM  
- [ ] Mark propagation validates quiz flow  
- [ ] Unit tests for marking and firing rules  

---

## 🧪 Testing Plan
- Unit tests for place marking and transition firing  
- Integration tests with the existing state machine  
- Reachability tests for quiz flow completeness  
- Error handling tests for invalid transitions  

---

## ⏱️ Timeframe
Estimated completion time: 4 days / 1 week

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
Suggested developer: @amtrevisan 
