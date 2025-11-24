---
issue_number: 335
title: "[Lecture Topic Task]: <Risk trees for quiz risk checking>"
state: "closed"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/335"
author: "Adriel-bracero"
labels: [
  "Team 4",
  "Task: lecture-topic",
  "state: concluded"
]
created_at: "2025-11-17T21:13:03Z"
updated_at: "2025-11-21T17:44:53Z"
---

# [Lecture Topic Task]: <Risk trees for quiz risk checking>

- **Issue:** [335](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/335)
- **Author:** @Adriel-bracero
- **Labels:** [
  "Team 4",
  "Task: lecture-topic",
  "state: concluded"
]
- **Created:** 2025-11-17T21:13:03Z

## Details
## 🎯 Objective
Create structured risk analysis risk trees (fault trees / event trees) for pronunciation coach features (session lifecycle, recording/persistence/sync, prosody detection). Produce prioritized risk trees, quantitative/qualitative risk assessments, and concrete mitigations that developers can implement or review.

---

## 📝 Description
This spike builds risk trees that expose how failures, resource constraints, or edge cases can lead to incorrect behavior or bad user outcomes. It directly references and maps risks to existing artifacts:

Statechart / Petri net: map where transitions or resource regions create failure modes (e.g., mic contention, blocked upload queue).

Indicate which classes are implicated in each risk scenario (LocalStore, UploadQueue, MergeOperator, Attempt, AudioSample, etc.).

Prosody detection and noise robustness: list model / pipeline weaknesses (false stress detection under low SNR, pitch-tracking failure on short tokens).

Persistence / merge: identify risks from duplicate events, lost events, or merge conflicts.


Deliverables should include one or more risk-tree diagrams (editable), a prioritized risk register (risk, cause, probability estimate or qualitative rating, severity/impact, mitigation), and recommended monitoring/CI checks or small proof of concept mitigations (e.g., bounded queue, conservative feedback thresholds, retry/backoff, short-term local retry logs).

---

## ✅ Acceptance Criteria
At least two editable risk-tree diagrams (SVG, draw.io, or PlantUML):

Fault tree for session-level failures (e.g., recording fails to start; evaluation missing).

Event tree for persistence/sync failures (e.g., upload failure → duplicate events → inconsistent aggregates).

A risk register (spreadsheet or table) listing each risk, root causes, likelihood (High/Med/Low), impact (High/Med/Low), and prioritized mitigations.

Mapping section that links each high-priority risk to the relevant statechart place(s), Petri-net region(s), and class(es) (so devs know where to apply fixes).

Proposed mitigations for top-5 risks (code pattern, configuration, monitoring metric, and acceptance test or CI check). Example mitigations: bounded UploadQueue + backoff, stable event IDs + deduper, conservative UI thresholds under low SNR, forced-alignment fallback, mic-availability guard.

Short experiment or PoC plan (one-paragraph each) for validating the two highest-priority mitigations (what to measure, success criteria).

---

## 🧪 Testing Plan
Implement quick tests or unit-test sketches where applicable (e.g., simulate upload failures and assert UploadQueue backoff + no data loss).

Define monitoring checks (examples): queue depth alert, consecutive upload failure rate, rate of persist retries, prosody confidence distribution under field SNR — add these to acceptance criteria for final mitigation.

---

## ⏱️ Timeframe
Estimated completion time: 5 days  

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

