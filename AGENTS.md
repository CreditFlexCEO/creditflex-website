# CreditFlex LLC — Development rules

These instructions apply to all work in this repository. Owner-approved designs, code, functionality, content, and assets are the baseline. Build upon them; do not replace them.

## Scope and preservation
- Inspect the actual existing code and relevant project files before editing. Do not guess at implementation details.
- Make the smallest complete change needed for the owner's request. No unrelated refactoring, feature additions, cosmetic improvements, file renames, dependency upgrades, or architecture changes.
- Preserve existing navigation, buttons, forms, dashboards, lessons, quizzes, dispute tools, data, authentication, integrations, and accessibility.
- Preserve approved layouts, colors, fonts, logos, pictures, copy, and responsive behavior unless the owner explicitly requests a change.
- Sunny is the permanent face of CreditFlex LLC. The approved master is `CreditFlex_Sunny_MASTER_DO_NOT_CHANGE.png` in the owner's ChatGPT Library. Retrieve that exact image; do not regenerate, redesign, or substitute the avatar. No changes to her face, hairstyle, skin tone, makeup, or other approved details. Use the same identity for the landing page, Academy, advertisements, and videos.
- Prioritize functional, informative, accessible Academy lessons, then other requested functionality, before optional cosmetic work. Preserve previously approved lesson designs and content; revise only the requested class or feature.

## Git workflow and recovery
- Before significant work, identify the current commit and create a recovery branch or tag. The initial recovery branch is `backup/pre-development-2026-11-15`; keep it unchanged.
- Use a separate task branch for each functional change. Do not push functional changes directly to main.
- Review the diff against the baseline; commit only files relevant to the task. Use descriptive commit messages.
- Test on the task branch, document results, and present the change for owner review. Merge into main only after owner approval. Never force-push, rewrite approved history, or delete recovery branches without explicit permission.
- If a change breaks approved functionality, stop and revert the specific change or restore from a known recovery point with the owner's approval. Do not overwrite unrelated work.

## Quality, safety, and verification
- Deliver complete, working code; never present placeholders, fake functionality, or inert buttons as finished features.
- Preserve security controls, privacy, existing data, and access policies. Never expose secrets or personal financial information. Do not weaken authentication, authorization, or row-level security to make a feature work.
- The existing browser-storage demonstration is not a secure production account system. Use sample data for prototype testing; do not collect real sensitive customer information until secure storage and access controls are verified.
- Test the requested behavior and relevant existing functions, including errors, links, accessibility, and mobile layout where applicable. Verify deployment separately.
- Distinguish proposed, implemented, tested, and deployed work. Never claim testing or deployment without evidence.
- Obtain explicit owner approval before major changes to approved design, architecture, database schema, security controls, project scope, or any paid service/credits. Disclose cost first. This includes HeyGen video generation.
- If access, tooling, or verification is unavailable, state the limitation; do not invent a successful result.

## Required change report
After each task, state:
1. The requested change and what was actually changed.
2. Modified files and the commit or branch.
3. What was preserved.
4. Tests actually run and their results; list anything untested.
5. Remaining limitations, costs, and whether the change is awaiting approval, merged, or deployed.

The owner's explicit instructions override proposed improvements. Do not take creative liberties.
