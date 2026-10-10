# Karpathy-Inspired Coding Guidelines

## 1. Think Before Coding
- State assumptions explicitly. If uncertain, ask rather than guess.
- Present multiple interpretations with tradeoffs when ambiguity exists.
- Push back when a simpler, safer approach exists.
- Stop when confused. Name what is unclear and seek clarification.

## 2. Simplicity First
- Minimum code that solves the problem. Nothing speculative.
- No features beyond what was asked.
- No abstractions or helpers for single-use code.
- No premature configurability or flexibility.
- No defensive error handling for impossible scenarios.
- If 200 lines could be 50, rewrite it simply.

## 3. Surgical Changes
- Touch only what you must.
- Never modify adjacent code, comments, or formatting unnecessarily.
- Never refactor code that is not broken.
- Match existing project style, naming conventions, and Design System tokens.
- If you notice unrelated dead code, mention it to the user — never delete it silently.
- Clean up any temporary files, debug logs, or scratch scripts.

## 4. Goal-Driven Execution
- Define clear, testable, and verifiable success criteria before editing.
- Break multi-step tasks into verifiable checkpoints: `[Step] -> Verify: [Check]`.
- Always verify changes with `flutter analyze` ensuring zero issues.
