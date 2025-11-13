---
issue_number: 258
title: "[Lecture Topic Task]: <Petri net models about quiz session flow and offline sync>"
state: "closed"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/258"
author: "Adriel-bracero"
labels: ["documentation","Team 4","Task: lecture-topic","state: concluded"]
created_at: "2025-11-04T04:27:03Z"
updated_at: "2025-11-09T14:57:57Z"
---

# [Lecture Topic Task]: <Petri net models about quiz session flow and offline sync>

- **Issue:** [258](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/258)
- **Author:** @Adriel-bracero
- **Labels:** ["documentation","Team 4","Task: lecture-topic","state: concluded"]
- **Created:** 2025-11-04T04:27:03Z

## Details
## 🎯 Objective
Study how Petri nets can model, analyze, and validate concurrent aspects of the quiz flow and offline sync/merge logic, and produce implementable artifacts (models, diagrams, simulation scripts, and integration notes) that help developers detect deadlocks, resource contention, and ensure liveness and boundedness in the app workflow.

---

## 📝 Description
Using the Petri nets lecture as reference, investigate how Petri net models (place-transition nets or colored Petri nets, where appropriate) can represent:

The quiz session lifecycle and per-question interaction (display → answer → prompt → recording → evaluation → persist → next).

Concurrent/shared resources (microphone, network/upload queue, export worker) and how those resources are allocated.

Offline/online synchronization and merge operations (how concurrent syncs and merges interact).

Produce clear Petri net diagrams, a short primer linking lecture concepts to our system, and a small prototype or simulation (script or model file) that exercises typical concurrent scenarios (simultaneous uploads, interrupted recording, resume + merge).

---

## ✅ Acceptance Criteria
Short primer (1 page) mapping Petri net concepts from the lecture to our app (places, transitions, tokens, firing rules, marking) and why those properties matter (deadlock, liveness, boundedness).

 Petri net diagrams:

A place-transition net for the quiz session flow (single session).

A net that models concurrent sync/merge processes and shared resources (microphone, network).

 A simulation/prototype (small script or model file for a Petri net tool) that can run scenarios and produce traces or reachability checks (examples: simulate two concurrent uploads, simulate crash-and-resume with merge). Include instructions to run it.

 Analysis notes showing findings for each model: possible deadlocks, resource contention, required capacity bounds (e.g., queue size), and recommended guards or redesigns to avoid issues.

 Deliverables packaged as editable files (diagram SVG or PNG, model/simulation file, and a short DOCX or Markdown report). 

---

## 🧪 Testing Plan
Create scenario scripts or model inputs for the simulation: normal flow, concurrent uploads, recording while an upload is ongoing, crash during upload then resume and merge.

For each scenario, run the model and inspect markings and firing sequences to check:

No reachable deadlock states in normal operation.

Boundedness: no unbounded token growth (queue overflow) under expected load.

Liveness: critical transitions (e.g., persist, export) remain fireable under reasonable conditions.

---

## ⏱️ Timeframe
Estimated completion time: 2 days / 1 week 

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
Suggested developer: @Adriel-bracero  
