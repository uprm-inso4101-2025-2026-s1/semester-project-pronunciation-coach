---
issue_number: 123
title: "[Lecture Topic Task]: <Statechart Creation for Quiz Progress Tracking>"
state: "closed"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/123"
author: "Adriel-bracero"
labels: ["documentation","Team 4","Task: lecture-topic","state: concluded"]
created_at: "2025-10-02T02:53:00Z"
updated_at: "2025-10-16T19:09:06Z"
---

# [Lecture Topic Task]: <Statechart Creation for Quiz Progress Tracking>

- **Issue:** [123](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/123)
- **Author:** @Adriel-bracero
- **Labels:** ["documentation","Team 4","Task: lecture-topic","state: concluded"]
- **Created:** 2025-10-02T02:53:00Z

## Details
## 🎯 Objective

Goal: Create a proper, implementation-ready statechart diagram that models the internal logic flow of the Quiz Progress Tracking and Report feature. The statechart shall be based on the class lecture material (Statecharts PDF) and be detailed enough to implement the behavior later.

---

## 📝 Description
This task applies the Statecharts lecture material to produce a complete statechart that governs the quiz progress tracking and reporting flow. Deliverables must include a clear diagram plus an implementation-ready specification.

Work to include:
Review the lecture PDF (Statecharts lecture notes) and apply the relevant concepts (hierarchical states, transitions, guards/conditions, entry/exit actions, history states, orthogonal regions) to the quiz progress domain. 

Produce a visual statechart diagram that models the full quiz progress tracking flow, including session lifecycle, per-question states, recording/evaluation states, summary/export flow, error handling, and any parallel regions needed (e.g., network state). The diagram should follow standard statechart notation taught in the lecture. 

Produce a developer specification (markdown) that enumerates: states, events, transitions, guards/conditions, entry/exit actions, and history semantics. This spec must map each element back to the lecture concepts so reviewers can verify correctness. 

Include implementation notes for Flutter/Dart: recommended state-machine library (or pattern), suggested file/module boundaries, and a short code sketch showing how to wire the statechart to UI events and persistence.

Provide small example scenarios (at least 3) traced through the statechart (e.g., normal session finish → export success, interrupted session + resume, export failure + retry) so reviewers can follow behavior end-to-end.

---

## ✅ Acceptance Criteria
A visual statechart diagram representing the full quiz progress tracking logic. The diagram must be clear, use standard statechart notation, and be checked against lecture concepts. 

 A developer specification (MARKDOWN) that enumerates: top-level and nested states, events, transitions, guards, entry/exit actions, history semantics, and any orthogonal regions. Each item in the spec must include a 1–2 sentence rationale and link back to the lecture concept where appropriate. 

 At least three worked scenarios traced through the statechart (text traces showing the sequence of events and resulting states), including normal and edge cases (resume after interruption, export failure + retry, low STT confidence handling).

 Implementation notes for Flutter/Dart that recommend an approach (state-machine library or pattern), show a minimal wiring sketch (pseudo-code or short Dart snippet), and list which UI components / modules the statechart will control.

---

## 🧪 Testing Plan
Traceability check: each major state/transition must point back to a lecture concept (hierarchy, guard, entry/exit)  

Scenario walkthroughs: run through the three provided scenarios and verify that the state transitions and actions are correct and cover edge cases.

Implementation readiness check: The implementation notes and wiring sketch must be sufficient in order for the logic flow to be properly implemented in the actual code.

---

## ⏱️ Timeframe
Estimated completion time:  2-3 days   

---

## ⚡ Urgency
- [ ] Low  
- [ ] Medium  
- [✅] High  

---

## 🎚️ Difficulty
- [ ] Easy  
- [ ] Moderate  
- [✅] Hard  

---

## 👨‍💻 Recommended Assigned Developer
Suggested developer: @Adriel-Bracero  
