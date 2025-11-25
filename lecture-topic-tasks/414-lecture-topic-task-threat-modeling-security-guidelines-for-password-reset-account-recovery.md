---
issue_number: 414
title: "[Lecture Topic Task]: Threat Modeling & Security Guidelines for Password Reset / Account Recovery"
state: "open"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/414"
author: "kevinlara1"
labels: [
  "documentation",
  "Team 1",
  "Task: lecture-topic",
  "state: waiting for dev"
]
created_at: "2025-11-25T01:10:51Z"
updated_at: "2025-11-25T22:05:44Z"
---

# [Lecture Topic Task]: Threat Modeling & Security Guidelines for Password Reset / Account Recovery

- **Issue:** [414](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/414)
- **Author:** @kevinlara1
- **Labels:** [
  "documentation",
  "Team 1",
  "Task: lecture-topic",
  "state: waiting for dev"
]
- **Created:** 2025-11-25T01:10:51Z

## Details
🎯 Objective

Analyze the security risks and requirements of the Pronunciation Coach password-reset (forgot-password) and account-recovery flow using software engineering risk/threat-analysis concepts, and produce concrete guidelines and checklists that the team can use to harden this feature.

⸻

📝 Description

The focus is specifically on the password reset / account recovery flow recently implemented with Supabase (email magic-link / password-recovery events), not on initial account creation (which is already covered by other LTTs).

This will:
	•	Review lecture material on:
	•	Software risks and fault analysis
	•	Non-functional requirements and security quality attributes
	•	Risk analysis methods (e.g., risk trees, impact matrix, STRIDE-style threat modeling)
	•	Study external best-practice sources on secure password reset and account recovery, for example:
	•	OWASP “Forgot Password Cheat Sheet” and general Authentication Cheat Sheet
	•	NIST SP 800-63B Digital Identity Guidelines (recommendations on authentication, password policies, and recovery channels)
	•	Identify typical threats for password reset/account recovery in a Supabase-backed mobile app:
	•	Email interception, link reuse, token theft, guessing/reset-spam, account enumeration, social-engineering vectors, etc.
	•	Map those threats to:
	•	Mitigation strategies (rate limiting, token expiration, single use of reset links, UX wording, logging/monitoring, etc.).
	•	Concrete security/non-functional requirements for the Pronunciation Coach app.
	•	Produce a short, structured PDF (or AsciiDoc/Markdown for later integration) that includes:
	•	A threat model overview for the forgot-password flow (actors, assets, trust boundaries).
	•	A risk/impact table linking each threat to likelihood, impact, and mitigation.
	•	A checklist of security requirements and “Do/Don’t” guidelines for developers when modifying auth flows.
	•	A brief gap-analysis comparing current implementation behavior (as seen in code + Supabase docs) against the recommended practices.

⸻

✅ Acceptance Criteria
	•	A 3–6 page PDF that documents:
	•	Summary of relevant lecture concepts (risk analysis, NFRs for security, threat modeling) applied to password reset.
	•	Clear description of the current password-reset flow in Pronunciation Coach (based on code and Supabase behavior).
	•	Threat model for the flow (assets, actors, trust boundaries, main threats).
	•	Risk/impact table with at least 8–10 identified risks and proposed mitigations.
	•	List of concrete security requirements/guidelines for password reset & account recovery in this project.
	•	Short gap-analysis: which recommendations are already satisfied by the current implementation and which require future work.
	•	Document references at the end (at least 3–5 real sources, including OWASP and one standards/academic reference).
	•	Document is uploaded/linked in the issue and is understandable by other team members without extra explanation.

⸻

🧪 Testing Plan
	•	Self-review against lecture slides/notes to ensure all cited concepts are correctly applied.
	•	Manual review of the current forgot-password implementation and Supabase auth configuration to verify that the described flow matches reality.
	•	Cross-check the final checklist against OWASP and NIST sources to confirm that no critical recommendation is contradicted.

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
