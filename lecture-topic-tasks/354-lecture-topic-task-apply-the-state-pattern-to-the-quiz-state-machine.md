---
issue_number: 354
title: "[Lecture Topic Task]: Apply the State Pattern to the Quiz State Machine"
state: "open"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/354"
author: "iralys-sanchez18"
labels: [
  "Team 4",
  "Task: lecture-topic",
  "state: waiting for team lead"
]
created_at: "2025-11-22T20:50:32Z"
updated_at: "2025-11-23T05:23:19Z"
---

# [Lecture Topic Task]: Apply the State Pattern to the Quiz State Machine

- **Issue:** [354](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/354)
- **Author:** @iralys-sanchez18
- **Labels:** [
  "Team 4",
  "Task: lecture-topic",
  "state: waiting for team lead"
]
- **Created:** 2025-11-22T20:50:32Z

## Details
## 🎯 Objective
Apply the State Pattern to the quiz flow by formalizing the existing quiz state transitions in quiz_state_machine.dart. This will align the quiz’s implementation with the Design Patterns material from the Software Design lecture (software-design.pdf), without altering the quiz’s behavior.

---

## 📝 Description
The current quiz flow already behaves like a state machine, transitioning between states such as Question -> Result -> Restart.  However, this structure is not explicitly expressed using a design pattern. According to the Software Design lecture (software-design.pdf), the state pattern provides a reusable way to model objects whose behavior depends on internal state. The quiz’s logic fits this pattern, and this issue formalizes it by creating a simple abstraction for quiz states.

This task will:
- Add a minimal QuizState abstraction (interface or class).
- Represent at least two states (QuestionState, ResultsState) using this pattern.
- Update quiz_state_machine.dart to handle transitions through QuizState.next().

The quiz’s UI and behavior will remain unchanged; only the internal structure of the state machine is refined to match the design pattern described in the lecture.

---

## ✅ Acceptance Criteria 
- [x] A QuizState abstraction exists (class or interface) representing a quiz state.
- [x] At least two concrete quiz states (ex. QuestionState, ResultsState) implement this abstraction.
- [x] quiz_state_machine.dart assigns transitions through the State Pattern logic.
- [x] Existing quiz behavior remains unchanged.
- [x] Documentation inside the file explains the changes.

---

## 🧪 Testing Plan
How will this be tested?  
- Run the quiz before and after the changes to confirm behavior is identical.
- Verify that advancing the quiz causes correct state transitions.
- Use temporary debug prints or logging to verify the correct state is active at each transition.
- Ensure no crashes occur when transitioning between states.

---

## ⏱️ Timeframe
Estimated completion time: 1 day

---

## ⚡ Urgency
- [ ] Low  
- [ ] Medium  
- [x] High  

---

## 🎚️ Difficulty
- [ ] Easy  
- [x] Moderate  
- [ ] Hard  

---

## 👨‍💻 Recommended Assigned Developer
Suggested developer: _@iralys-sanchez18_  

