---
issue_number: 261
title: "[Lecture Topic Task]: Risk Tree Analysis for Audio Feedback"
state: "closed"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/261"
author: "Gabriel-Visbal"
labels: ["documentation","Team 3","Task: lecture-topic","state: concluded"]
created_at: "2025-11-06T22:14:20Z"
updated_at: "2025-11-09T21:42:52Z"
---

# [Lecture Topic Task]: Risk Tree Analysis for Audio Feedback

- **Issue:** [261](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/261)
- **Author:** @Gabriel-Visbal
- **Labels:** ["documentation","Team 3","Task: lecture-topic","state: concluded"]
- **Created:** 2025-11-06T22:14:20Z

## Details
## 🎯 Objective
Analyze and document potential failures in the Pronunciation Feedback Audio Processing Module using Risk Tree Analysis (Chapter 3, slides 21–22). The goal is to identify how different component-level failures can lead to the main system risk: “Inaccurate Pronunciation Feedback Provided.”

This task deepens the general Risk Analysis process by applying it to a specific technical area, illustrating how structured failure decomposition supports early detection and mitigation of reliability issues within the Pronunciation Coach system.

---

## 📝 Description
This activity applies Risk Tree Analysis to visualize and understand how multiple audio-related issues can combine to affect feedback accuracy. The diagram should represent hierarchical relationships among potential failure sources and show how they logically contribute to the main risk.

Steps:
- Define the root risk: "Inaccurate Pronunciation Feedback Provided."
- Identify intermediate nodes: Subsystems such as microphone capture, MFCC feature extraction, and native model comparison.
- Break down into leaf nodes: Specific, measurable failure events (e.g., microphone static, sampling rate mismatch, corrupted MFCC coefficients).
- Connect with logic gates (AND/OR): Indicate whether combinations of failures are required or if one alone is sufficient.

**Lecture Concepts Applied:**

- Risk Tree structure (slide 21)
- AND/OR failure nodes (slide 21)
- Leaf nodes vs decomposable nodes (slide 22)

Why This Matters:
The MFCC-based pronunciation system (mentioned in Section 2.1.5) depends on reliable audio capture and processing. Understanding failure combinations helps us prioritize which components need the most robust error handling.

**Deliverable:** A documented risk tree diagram showing:

- Root risk: "Inaccurate Pronunciation Feedback Provided"
- Component failures: microphone, MFCC algorithm, native models
- Logical relationships (AND/OR nodes)
- Leaf nodes representing basic failure events

---

## ✅ Acceptance Criteria
-  [ ] Risk tree diagram created (draw.io, Mermaid, or hand-drawn + photo)
-  [ ] Root node clearly identifies main system risk
-  [ ] At least 3 levels of decomposition (root → intermediate → leaf nodes)
-  [ ] AND/OR logic nodes properly labeled
-  [ ] Minimum 8 leaf nodes identified (specific failure events)
-  [ ] Documentation added to Section 2.2 or Logbook

---

## 🧪 Testing Plan
- Review with team to verify failure scenarios are realistic
- Cross-reference with existing requirements (Section 2.2.4-2.2.5)
- Validate against personas (Maria's bus scenario, David's practice sessions)

---

## ⏱️ Timeframe
Estimated completion time: 2-3 hours

---

## ⚡ Urgency
- [ ] Low  
- [X] Medium  
- [ ] High  

---

## 🎚️ Difficulty
- [X] Easy  
- [ ] Moderate  
- [ ] Hard  

---

## 👨‍💻 Recommended Assigned Developer
Suggested developer: @Gabriel-Visbal 
