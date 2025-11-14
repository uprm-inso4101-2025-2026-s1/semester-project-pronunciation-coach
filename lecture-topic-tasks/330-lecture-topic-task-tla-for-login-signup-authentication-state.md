---
issue_number: 330
title: "[Lecture Topic Task]: TLA+ for login/signup authentication state"
state: "open"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/330"
author: "JuliT02"
labels: [
  "Team 1",
  "Task: lecture-topic",
  "state: waiting for dev",
  "state: in progress"
]
created_at: "2025-11-14T17:08:18Z"
updated_at: "2025-11-14T17:53:25Z"
---

# [Lecture Topic Task]: TLA+ for login/signup authentication state

- **Issue:** [330](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/330)
- **Author:** @JuliT02
- **Labels:** [
  "Team 1",
  "Task: lecture-topic",
  "state: waiting for dev",
  "state: in progress"
]
- **Created:** 2025-11-14T17:08:18Z

## Details
## 🎯 Objective
Formally verify the correctness of the login/signup authentication state machine using TLA+ to eliminate race conditions, stuck loading states, and unsafe mounted usage in Flutter.

---

## 📝 Description
Our LoginPage and SigninPage involve complex state interactions:
 - Async Supabase calls with conditional navigation (session vs. email confirm) 
 - Loading states (_loading, _loadingSystem)  
 - Form validation (password strength, confirmation matching)  
 - Widget disposal mid-request (mounted checks)
Manual testing and unit tests cannot exhaustively cover edge cases like:   
User submits → network starts → user navigates back → widget disposes → network fails → code tries setState   

---

## ✅ Acceptance Criteria
- [ ] TLC model checker verifies all invariants pass: 
- [ ] TLA+ spec AuthStateMachine.tla added to tlaplus/ directory 
- [ ] Documentation created for the results

---

## 🧪 Testing Plan
- TLA+ model checking: Run TLC locally + in CI to exhaustively verify invariants.  
- Counterexample validation: For any TLC violation, reproduce in Flutter via integration test.  
- Smoke test: Manually verify auth flow still works after spec alignment.  
 - CI guardrail: PRs modifying auth code fail if make tla-check fails.
     

---

## ⏱️ Timeframe
Estimated completion time: 2-3 days

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
Suggested developer: @JuliT02 

