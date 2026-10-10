---
name: karpathy-guidelines
description: Core software engineering principles derived from Andrej Karpathy's observations on LLM coding pitfalls (Think Before Coding, Simplicity First, Surgical Changes, Goal-Driven Execution). Use whenever planning, coding, or refactoring in StudyDeck AI.
---

# Karpathy-Inspired Coding Guidelines

## Purpose
This skill enforces disciplined, senior-level software engineering practices for AI pair programming, directly eliminating common LLM pitfalls: hallucinated assumptions, over-engineering, orthogonal code breakage, and lack of verification.

## 1. Think Before Coding
- **Never guess silently**: If a requirement has multiple interpretations or lacks clarity, pause and present the options along with their tradeoffs.
- **Surface assumptions**: State what you assume before writing any code.
- **Push back when warranted**: If the user suggests an approach that is overly complicated, propose a simpler and more robust alternative.

## 2. Simplicity First
- **Minimal code**: Write the smallest amount of code that completely solves the problem.
- **No speculative features**: Build only what was requested right now, not what might be needed tomorrow.
- **No one-off abstractions**: Avoid creating unnecessary classes, interfaces, wrappers, or managers for single-use logic.
- **Eliminate boilerplate**: If 200 lines can be cleanly expressed in 50 lines, rewrite it.

## 3. Surgical Changes
- **Localized edits**: Modify strictly the lines/functions necessary to complete the task.
- **Preserve surrounding code**: Do not touch adjacent comments, formatting, or unrelated logic.
- **Match project conventions**: Strictly adhere to the project's established styling (`design-system.md`, `THEME_STANDARDS.md`).
- **Never delete unrelated dead code**: Report it to the user instead of deleting it.

## 4. Goal-Driven Execution
- **Verifiable checkpoints**: Structure complex tasks into `[Action] -> [Verification Check]`.
- **Validation step**: Always validate Flutter code using `flutter analyze` ensuring 0 errors before considering any task complete.
