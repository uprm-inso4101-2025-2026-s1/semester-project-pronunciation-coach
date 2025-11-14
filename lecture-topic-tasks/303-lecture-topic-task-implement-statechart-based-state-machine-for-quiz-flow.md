---
issue_number: 303
title: "[Lecture Topic Task]: Implement Statechart-Based State Machine for Quiz Flow"
state: "open"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/303"
author: "amtrevisan"
labels: ["Team 3","Task: lecture-topic","state: in progress"]
created_at: "2025-11-11T23:21:15Z"
updated_at: "2025-11-12T18:24:30Z"
---

# [Lecture Topic Task]: Implement Statechart-Based State Machine for Quiz Flow

- **Issue:** [303](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/303)
- **Author:** @amtrevisan
- **Labels:** ["Team 3","Task: lecture-topic","state: in progress"]
- **Created:** 2025-11-11T23:21:15Z

## Details
## 🎯 Objective
Build and integrate a working **hierarchical state machine** (statechart) that directly controls the quiz flow at runtime replacing the current screen-based logic with structured, event-driven state transitions.

---

## 📝 Description
Develop an **implementation** of a **functional state machine system** that manages the live quiz process through clearly defined states and transitions.  
The focus is on *execution and interaction*, not on theoretical modeling.  
The implementation should handle all quiz flow stages — from waiting to start, through answering and evaluation, to displaying results — while allowing nested (hierarchical) states and error handling.

This task demonstrates practical use of **statecharts** in code, showing how runtime state control can simplify flow logic and UI coordination.

---

## ✅ Acceptance Criteria
- [ ] `StateMachine` class implemented with support for nested (hierarchical) states  
- [ ] Quiz flow states defined (idle → selecting → answering → evaluating → results)  
- [ ] Event-driven transitions and guards working correctly  
- [ ] Integrated with quiz UI (buttons, progress, feedback)  
- [ ] Unit tests verifying transitions, entry/exit actions, and hierarchy behavior  

---

## 🧪 Testing Plan
- Unit tests for transition logic and event handling  
- Integration tests confirming quiz state flow correctness  
- Manual UI checks of quiz progression and recovery from error states  
- Validation of nested state entry/exit consistency  

---

## ⏱️ Timeframe
Estimated completion time: 1 week

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
Suggested developer: @AlexMoralesDev
