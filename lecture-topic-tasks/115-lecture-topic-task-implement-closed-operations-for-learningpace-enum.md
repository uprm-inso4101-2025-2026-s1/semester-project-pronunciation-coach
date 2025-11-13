---
issue_number: 115
title: "[Lecture Topic Task]: Implement Closed Operations for LearningPace Enum"
state: "closed"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/115"
author: "Gabriel-Visbal"
labels: ["Team 3","Task: lecture-topic","state: concluded"]
created_at: "2025-09-30T18:28:04Z"
updated_at: "2025-10-07T17:46:37Z"
---

# [Lecture Topic Task]: Implement Closed Operations for LearningPace Enum

- **Issue:** [115](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/115)
- **Author:** @Gabriel-Visbal
- **Labels:** ["Team 3","Task: lecture-topic","state: concluded"]
- **Created:** 2025-09-30T18:28:04Z

## Details
## 🎯 Objective
Refactor LearningPace implementation to follow algebraic design principles, ensuring all operations are closed under the carrier set.

---

## 📝 Description
Currently, the LearningPace enum and its associated operations don't follow algebraic design principles as described in the Software Engineering course materials (Algebras lecture).
**Background:** An algebra consists of:

- A carrier set (our LearningPace enum values)
- A finite set of operations that are closed (take elements from the set and return elements from the same set)

**Current Issues:**

- Operations are scattered across multiple files
- No explicit algebraic operations like next(), previous(), or default()
- setPace() modifies global state instead of working with pure values
- Missing self-contained operations that would make the type more maintainable

**References:**

- Lecture: Algebras (September 11, 2020) - Section "how do they relate to software engineering?"
- Key principle: "concepts and operations easier to understand if self-contained"

---

## ✅ Acceptance Criteria

-  [ ] LearningPace enum has a static defaultPace getter returning LearningPace.casual
-  [ ] next() method implemented (casual→standard→intensive→intensive)
-  [ ] previous() method implemented (casual→casual, standard→casual, intensive→standard)
-  [ ] minutes getter returns appropriate Int values (5, 15, 30)
-  [ ] Helper getters added: displayName, subtitle, icon
-  [ ] MyAppState uses algebraic operations (incrementPace(), decrementPace())
-  [ ] All operations maintain closure (stay within LearningPace set)
-  [ ] Code includes comments documenting the algebra structure
-  [ ] Existing functionality preserved (persistence, UI selection)

---

## 🧪 Testing Plan
Unit Tests:

- Test next() boundary: intensive.next() == intensive
- Test previous() boundary: casual.previous() == casual
- Test defaultPace returns casual
- Test minutes returns correct values for each pace

Integration Tests:

- Verify incrementPace() cycles through paces correctly
- Verify decrementPace() cycles through paces correctly
- Verify persistence still works after refactor

Manual Testing:

- Test UI pace selection
- Test increment/decrement buttons (if added)
- Verify SharedPreferences still saves/loads correctly

---

## ⏱️ Timeframe
Estimated completion 2 - 3 days  

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
Suggested developer: @Gabriel-Visbal  
