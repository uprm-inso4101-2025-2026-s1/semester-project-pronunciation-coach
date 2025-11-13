---
issue_number: 184
title: "[Lecture Topic Task]: <Algebras and Quiz Progress Tracking>"
state: "closed"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/184"
author: "Adriel-bracero"
labels: ["Team 4","Task: lecture-topic","state: concluded"]
created_at: "2025-10-16T20:00:52Z"
updated_at: "2025-10-24T04:15:03Z"
---

# [Lecture Topic Task]: <Algebras and Quiz Progress Tracking>

- **Issue:** [184](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/184)
- **Author:** @Adriel-bracero
- **Labels:** ["Team 4","Task: lecture-topic","state: concluded"]
- **Created:** 2025-10-16T20:00:52Z

## Details
## 🎯 Objective
Goal: Produce an implementation-ready specification that applies abstract algebra concepts from the lecture material to the Quiz Progress Tracking and Report feature. Deliver a short primer on the algebra concepts, mapped design patterns for persistence/aggregation/merge logic, and a small PoC (Proof of Concept) that demonstrates the ideas.

---

## 📝 Description
Use the Algebras lecture to produce a practical design and a short proof-of-concept showing how the lecture’s abstract algebra concepts help make persistence, aggregation, and merges deterministic and testable. Work to include:

A doc covering the lecture concepts: carrier sets, operations and closure, associativity, identity element, free monoid (event logs), and folding/interpretation. 

A mapping that shows how those lecture concepts apply to the quiz tracking system: event logs as free monoids, aggregates as algebraic values with merge and empty, and folding events into aggregates via a mapping. 

A developer spec (Python and Dart sketches) with function signatures and the algebraic laws to test (associativity and identity required).

A short Python PoC that implements aggregate, merge, empty, foldEvents, and unit checks for associativity and identity.

---

## ✅ Acceptance Criteria
Mapping document showing how lecture concepts map to event folding, aggregate merging, resume and export logic. 

 Interface spec with signatures (Python and Dart sketches) and the algebraic laws to test (associativity and identity).

 PoC Python script (≤ 300 lines) demonstrating foldEvents, merge, empty and unit assertions for associativity and identity.

---

## 🧪 Testing Plan
Unit tests in the PoC:
Associativity: merge(merge(a,b),c) == merge(a,merge(b,c)).
Identity: merge(a, empty()) == a == merge(empty(), a).
Fold/merge compatibility: foldEvents(events) == merge(foldEvents(chunk1), foldEvents(chunk2)).
Manual review: developer walkthrough of README and PoC.

---

## ⏱️ Timeframe
Estimated completion time: 3-7 days

---

## ⚡ Urgency
- [ ] Low  
- [ ] Medium  
- [✅] High  

---

## 🎚️ Difficulty
- [ ] Easy  
- [✅] Moderate  
- [ ] Hard  

---

## 👨‍💻 Recommended Assigned Developer
Suggested developer: @Adriel-bracero   
