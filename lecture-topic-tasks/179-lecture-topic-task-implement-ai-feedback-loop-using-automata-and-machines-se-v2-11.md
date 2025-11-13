---
issue_number: 179
title: "[Lecture Topic Task]: <Implement AI Feedback Loop using Automata and Machines (SE - V2:11)>"
state: "closed"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/179"
author: "pedroamorales"
labels: ["Task: lecture-topic","task: development","state: concluded"]
created_at: "2025-10-14T17:02:16Z"
updated_at: "2025-10-23T17:07:28Z"
---

# [Lecture Topic Task]: <Implement AI Feedback Loop using Automata and Machines (SE - V2:11)>

- **Issue:** [179](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/179)
- **Author:** @pedroamorales
- **Labels:** ["Task: lecture-topic","task: development","state: concluded"]
- **Created:** 2025-10-14T17:02:16Z

## Details
## 🎯 Objective
Apply the **Automata and Machines (SE - V2:11)** lecture to formalize how the application's **AI feedback engine** processes recorder user speech, evaluates their pronunciation, and returns adaptive and accurate responses. 

The goal is to model this flow as a **Deterministic Finite Automation (DFA)** to improve testability, traceability, and error handling in the pronunciation quiz cycle. This task ensures that every state in the feedback process (recording, analyzing, evaluating, and responding) can be validated and reused for further architecture tasks. 

---

## 📝 Description
The task consists of defining, modeling, and documenting the AI feedback cycle using automata concepts. 

**1. Conceptual Design**
- Model the feedback process as a DFA:
     >States: Idle, Listening, Processing, Feedback, Completed.
     >Inputs: Audio Input, AI Score, user acknowledgement, network status.
     >Outputs: Textual feedback, pronunciation score, transition triggers. 

- Define Transition Rules: what moves the automation from on state to another. 
- Handle error transitions (e.g., missing audio, API timeout → revert to Idle).

     
**2. Implementation Sketch** 
- Write a **pseudo-class or UML snippet** for a **FeedbackStateMechine** (Dart/Python)
- Include an **onEvent(event)** method that defines the transitions. **(PDF)**

**3. Visualization**
- Create a **state diagram** (PlantUML, draw.io, or Lucidchart)
- Show transitions like:

     >Idle → Listening → Processing → Feedback → Completed → Idle

**4. Research & Comparison**
- Briefly compare deterministic vs. nondeterministic automata in AI feedback contexts.
- Example: nondeterministic responses may arise from probabilistic AI scores; mitigate by defining acceptance thresholds.

---

## ✅ Acceptance Criteria 
- [ ] DFA state diagram included in the research PDF 
- [ ] State table created with at least 5 states and transitions. 
- [ ] Each transition mapped to real Flutter functionality (Idle → Listening = mic widget active).
- [ ]  Deterministic transitions confirmed (no undefined paths).
- [ ]  Automaton traceability included in test plan (test IDs per transition).
- [ ]  Lecture **SE - V2:11** is cited.

---

## 🧪 Testing Plan
**1. Unit Tests**
- Simulate events triggering transitions and assert expected next states.
- Mock AI API response to ensure ScoreReceived event transitions correctly.

**2. Integration Tests**
- Use Flutter’s integration_test package to test full cycles.
- Validate UI updates (feedback message and next question).

**3. Error Handling**
- Simulate timeout in Processing; verify return to Idle.
- Test invalid audio input (corrupted file).

**4. Traceability**
- Link test cases to Acceptance Criteria with IDs (e.g., AI-FSM-03).
     
---

## ⏱️ Timeframe
Estimated completion time: 2 - 3 Days

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
