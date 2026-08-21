---
name: tdd-workflow
description: Use this skill when implementing a code feature, bug fix, or refactor in a project that has (or should have) an automated test suite — unit or integration tests are a meaningful part of verifying correctness. Do NOT use for config-only changes, infra/shell scripting, dotfiles, window manager or system configuration (e.g. skhd, yabai, sketchybar), documentation edits, or any change where "write a failing test first" doesn't map to a real testable unit.
---

TDD protocol — follow exactly

1. Write the failing test first. Do not write implementation code yet.
2. Run the test yourself. Show me the full output and state in one line why it's red for the right reason (missing implementation, not a typo/import error/wrong assertion). Stop there and wait for my go-ahead before implementing.
3. Once I confirm, implement the minimal code to make it pass.
4. Compile errors, type errors, unrelated lint/build noise along the way: fix these yourself in a loop, don't wait on me — this is deterministic and doesn't need my judgment. Keep me posted on what you're fixing and why as you go, don't go silent.
5. The actual red → green transition on the test that matters: stop. Run it, show me the output, state why it's green for the right reason, update tasks/todo.md, and wait for my input before moving to the next item. Do not chain into the next feature on your own judgment that this one is "done."
6. After any correction I give you, add the pattern to tasks/lessons.md so you don't repeat it. If tasks/lessons.md already exists, append to it. If it doesn't exist but this project has otherwise adopted the tasks/ convention (e.g. tasks/todo.md exists), create tasks/lessons.md. If there's no tasks/ directory in this project at all, skip this step rather than introducing the convention unprompted.

If a task looks testable but the project has no test infrastructure set up yet, say so and ask whether to set it up or proceed without TDD for this task — don't silently skip the protocol or silently force test scaffolding onto a task that doesn't need it.
