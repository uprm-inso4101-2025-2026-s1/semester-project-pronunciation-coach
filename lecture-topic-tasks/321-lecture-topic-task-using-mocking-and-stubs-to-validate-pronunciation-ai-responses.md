---
issue_number: 321
title: "[Lecture Topic Task]: Using Mocking and Stubs to Validate Pronunciation AI Responses"
state: "open"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/321"
author: "pedroamorales"
labels: [
  "Task: lecture-topic",
  "state: concluded"
]
created_at: "2025-11-13T20:01:33Z"
updated_at: "2025-11-28T15:33:11Z"
---

# [Lecture Topic Task]: Using Mocking and Stubs to Validate Pronunciation AI Responses

- **Issue:** [321](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/321)
- **Author:** @pedroamorales
- **Labels:** [
  "Task: lecture-topic",
  "state: concluded"
]
- **Created:** 2025-11-13T20:01:33Z

## Details
## 🎯 Objective
Implement mocking and stubbing techniques to validate the Pronunciation AI feedback responses without relying on live API calls. The goal is to ensure the Flutter front-end and Python AI back-end integrate correctly by simulating AI responses for various pronunciation scenarios, improving test coverage, reliability, and speed during development.

---

## 📝 Description
The Pronunciation Coach app relies on AI-based scoring and feedback services to evaluate a user’s pronunciation. Testing these systems directly against the live AI can introduce latency, instability, and dependency issues. This task focuses on designing mock and stub modules that emulate AI responses, allowing developers to test the full feedback cycle deterministically.

**Implementation Steps:**

**1. Create AI Response Stub**

> - Implement a Python stub that simulates REST API endpoints for pronunciation scoring.
>
> - Provide static responses for test cases (e.g., “Excellent,” “Needs Improvement”).

**2. Develop Mock Objects**

> - Use Dart’s mockito or Python’s unittest.mock to emulate expected API behavior and network responses.

**3. Integration Testing**

> - Replace live API calls in the test environment with the mock/stub service.
>
> - Verify that the UI correctly displays feedback messages.

**4. Error Simulation**

> - Introduce controlled error states (e.g., timeout, invalid audio format) to test error-handling logic.

**5. Documentation**

> - Create a testing guide describing how mocks and stubs are integrated into the feedback pipeline.

---

## 🧪 Testing Plan

**1. Unit Testing**

> - Validate mock responses match expected output types.
> 
> - Ensure the UI reacts appropriately to stubbed results.

**2. Integration Testing**

> - Run end-to-end tests using the mocked service to verify feedback flow.

**3. Error Handling**

> - Simulate timeout and invalid data responses.
> - 
> - Confirm fallback or retry logic is triggered.

**4.** Performance Testing**

> - Measure response times compared to live AI to ensure test stability.

---

## ⏱️ Timeframe
Estimated completion time: **2-3 days**

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
