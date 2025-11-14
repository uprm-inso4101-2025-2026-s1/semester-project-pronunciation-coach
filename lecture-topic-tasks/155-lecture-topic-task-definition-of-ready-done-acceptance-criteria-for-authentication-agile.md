---
issue_number: 155
title: "[Lecture Topic Task] <Definition of Ready/Done & Acceptance Criteria for Authentication (Agile)>"
state: "closed"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/155"
author: "aryamdiaz"
labels: ["Team 1","Task: lecture-topic","state: concluded"]
created_at: "2025-10-07T14:03:56Z"
updated_at: "2025-10-07T17:15:54Z"
---

# [Lecture Topic Task] <Definition of Ready/Done & Acceptance Criteria for Authentication (Agile)>

- **Issue:** [155](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/155)
- **Author:** @aryamdiaz
- **Labels:** ["Team 1","Task: lecture-topic","state: concluded"]
- **Created:** 2025-10-07T14:03:56Z

## Details
**🎯 Objective**
Define a project-ready Definition of Ready (DoR) and Definition of Done (DoD) for the Authentication module, and write formal Acceptance Criteria (Given/When/Then) for its main stories (Sign In, Sign Up, Forgot Password, Remember Me, Validation). This task applies the Agile lecture and produces artifacts that the team can use to implement and validate PRs.

--

**📝 Description**
This task applies Agile lecture topics (INVEST, Acceptance Criteria, DoR/DoD) to standardize quality and verifiability for the Authentication module.

**Work to include**

1. Auth-specific DoR and DoD
- DoR: minimal conditions to start (clarity, dependencies, risks, preliminary test criteria).
- DoD: what must be true to close (tests pass, UI validations, error messages, CI green, evidence attached, docs updated).

2. Stories & Acceptance Criteria (G/W/T)
- Write 5–7 stories: Sign In, Sign Up, Forgot Password, Remember Me, Field Validations/Errors, optional Logout.
- Provide 3–5 acceptance criteria per story in Given/When/Then format, including edge cases.

3. Stories & Acceptance Criteria (G/W/T)
- Evaluate each story against INVEST and propose split/refactor if not Small/Testable.

4. Implementation readiness
- Specify how PRs will be validated (unit/integration/UI tests, screenshots/logs, CI checks).
- Map stories to existing backlog issues if available.

**Deliverables**
- docs/lecture_topics/agile-auth-dor-dod.md
- docs/lecture_topics/agile-auth-acceptance-criteria.md
Both must reference the Agile lecture.

--

**✅ Acceptance Criteria**
- Auth-specific DoR/DoD that reviewers can enforce on PRs.
- 5–7 Auth stories with Given/When/Then criteria covering happy path and errors.
- INVEST table with at least one concrete refinement per story.
- PR validation guide (checks/evidence).
- Files placed under /docs/lecture_topics/ and citing the Agile lecture.

--

**🧪 Testing Plan**
- _Traceability_: each criterion maps to a test ID and an Agile concept (INVEST/Acceptance). 
- _Edge cases review_: at least one error/validation criterion per story. 
- _PR readiness_: simulate a PR checklist (analyze + test + screenshots/logs) to prove DoD is verifiable.

--

**⏱️ Timeframe**
Estimated completion: 1–2 days.

--

**⚡ Urgency**
- [ ] Low 
- [ ] Medium 
- [ ] High

--

**🎚️ Difficulty**

- [ ] Easy 
- [ ] Moderate 
- [ ] Hard

--

**👩‍💻 Suggested Assignee**
@aryamdiaz 
