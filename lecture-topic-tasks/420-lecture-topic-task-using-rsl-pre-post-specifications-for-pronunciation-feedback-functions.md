---
issue_number: 420
title: "[Lecture Topic Task]: Using RSL Pre/Post Specifications for Pronunciation Feedback Functions"
state: "open"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/420"
author: "kevinlara1"
labels: [
  "documentation",
  "Team 1",
  "Task: lecture-topic",
  "state: waiting for manager"
]
created_at: "2025-11-26T20:11:46Z"
updated_at: "2025-11-27T01:21:31Z"
---

# [Lecture Topic Task]: Using RSL Pre/Post Specifications for Pronunciation Feedback Functions

- **Issue:** [420](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/420)
- **Author:** @kevinlara1
- **Labels:** [
  "documentation",
  "Team 1",
  "Task: lecture-topic",
  "state: waiting for manager"
]
- **Created:** 2025-11-26T20:11:46Z

## Details
🎯 Objective

Research how RAISE Specification Language (RSL) and pre/post-condition style specifications can be used to precisely describe core Pronunciation Coach operations, and produce a short document that applies these ideas to our project.

⸻

📝 Description

The course includes material on rigorous reasoning and formal specification using RSL (RAISE). However, the current Pronunciation Coach documentation focuses mainly on domain description, requirements, architecture, and implementation; it does not yet use pre-/post-condition specifications to describe how individual functions should behave.

The goal is to:
	1.	Review the RSL / rigorous-reasoning lecture material and the provided example files to understand how RSL uses preconditions and postconditions to specify operations.
	2.	Check 3–5 critical operations in the Pronunciation Coach codebase that relate to pronunciation feedback and quiz progression. Examples of candidate operations (subject to adjustment once inside the repo) include:
	•	“evaluate pronunciation” / “score recording” use case (converting speech-to-text/analysis into user feedback and a numeric score),
	•	“save quiz attempt” or “update quiz history and streaks”,
	•	“update achievements/XP based on quiz results”.
	3.	For each chosen operation, write an operation-level specification in terms of:
	•	a clear informal description of its preconditions (what must be true before calling it) and postconditions (what must be true after it finishes), and
	•	a sketch of the same idea in RSL style (using the patterns from the course examples), focusing on readability rather than full tool-checked correctness.
	4.	Analyze the benefits and trade-offs of using RSL-style pre/post specs in this project:
	•	How they can improve documentation, testing, and reasoning about edge cases (e.g., invalid input, inconsistent state, race conditions),
	•	Where they might be too heavy or not worth the effort for a student project.

The final output will show how RSL pre/post specifications could be applied to Pronunciation Coach’s feedback-related functions.

⸻

✅ Acceptance Criteria
	•	A short overview of RSL and pre/post-condition concepts based on the course material and at least one external reference.
	•	A list of 3–5 concrete Pronunciation Coach operations (from the actual codebase or clearly planned design) that are relevant to pronunciation feedback/quiz results.
	•	For each chosen operation, informal preconditions and postconditions written in clear, precise English.
	•	For at least 2 of the operations, a sample RSL-style specification (using the notation from the RSL lecture and examples).
	•	A short discussion section (≈ 1 page) reflecting on how these specs could help with testing, bug prevention, and maintenance, and where using RSL might be impractical.
	•	The document clearly links the work to the “rigorous reasoning / RSL” lecture topic, explaining which slides/sections are being applied.
	•	The document is committed and referenced in the main project documentation (for example, mentioned in the appropriate section or in the documentation logbook).

⸻

🧪 Testing Plan
	•	Content review
	•	Verify that each selected operation actually exists (or is clearly planned) in the Pronunciation Coach architecture/code.
	•	Check that preconditions and postconditions are logically consistent with existing requirements and behavior (no contradictions with current implementation or docs).
	•	Have at least one teammate or manager review the RSL examples for readability and consistency with the course syntax examples.
	•	Traceability check
	•	Confirm that the document references the relevant lecture/topic and that there is a clear mapping from at least one operation spec to existing or planned tests (e.g., how a unit/acceptance test could be derived from the pre/post conditions).

⸻

⏱️ Timeframe

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
Suggested developer: @kevinlara1 
