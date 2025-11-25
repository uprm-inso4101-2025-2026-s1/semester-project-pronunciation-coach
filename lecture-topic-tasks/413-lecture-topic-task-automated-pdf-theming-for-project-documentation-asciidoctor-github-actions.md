---
issue_number: 413
title: "[Lecture Topic Task]: <Automated PDF Theming for Project Documentation (AsciiDoctor + GitHub Actions)>"
state: "open"
url: "https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/413"
author: "Fernando18Torres"
labels: [
  "Task: lecture-topic",
  "state: in progress"
]
created_at: "2025-11-25T00:35:44Z"
updated_at: "2025-11-25T00:44:27Z"
---

# [Lecture Topic Task]: <Automated PDF Theming for Project Documentation (AsciiDoctor + GitHub Actions)>

- **Issue:** [413](https://github.com/uprm-inso4101-2025-2026-s1/semester-project-pronunciation-coach/issues/413)
- **Author:** @Fernando18Torres
- **Labels:** [
  "Task: lecture-topic",
  "state: in progress"
]
- **Created:** 2025-11-25T00:35:44Z

## Details
## 🎯 Objective
Integrate and automate custom AsciiDoctor PDF theming within the project’s GitHub Actions workflow to enhance document consistency and visual identity.

---

## 📝 Description
This task involves extending the existing .github/workflows/adoc-to-pdf.yml workflow to apply a custom AsciiDoctor theme (docs/pdf-theme.yml) to all generated PDFs. The goal is to ensure that team documentation (such as milestones, reports, and technical docs) has a unified visual format—using predefined role colors (e.g., .changed, .added, .removed) and consistent typography.
The theme will be version-controlled and automatically applied during the CI pipeline whenever .adoc files are updated.

Reference implementation example:
[/docs/pdf-theme.yml](/mnt/data/Pronounciation_Coach_App_Doc (3).pdf)
and the converter script scripts/pdf-converter-change-bars.rb.

---

## ✅ Acceptance Criteria
List the conditions that must be met for this issue to be considered complete.  
The docs/pdf-theme.yml file is recognized and applied during PDF generation
All .adoc files build into PDFs with consistent formatting and role-based styles
The GitHub Action successfully commits themed PDFs to docs/pdf/

 Theme roles (e.g., .changed, .added, .removed) display correct border colors in output

---

## 🧪 Testing Plan
How will this be tested?  
Push commits modifying .adoc files and verify new PDFs in docs/pdf/

Inspect role styles (red, green, dark red bars)

Validate that the theme loads correctly (no fallback to default)

Confirm logs contain “change-bar: ChangeBarPdfConverter loaded”

---

## ⏱️ Timeframe
Estimated completion time: 1 week_  

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
Suggested developer: _@Fernando18Torres_  

