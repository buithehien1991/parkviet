<!-- ak-managed-rules-engineer-start -->
# Development Rules

Use this file when editing code, tests, scripts, or configuration.

## Baseline

- Follow project docs in `docs/` and existing local patterns.
- Apply KISS and DRY. Deliver the full requested scope — do not trim, defer, or
  simplify away features the user explicitly asked for. Add nothing beyond the
  request. When the user passes `--yagni`, additionally apply YAGNI (You Aren't
  Gonna Need It): challenge and cut any scope not needed for the stated outcome.
- Implement real behavior. Do not add fake data, mocks, or temporary shortcuts just to satisfy a check.
- Keep changes scoped to the request and the affected contracts.
- Use descriptive kebab-case file names for new files when the repo has no stronger convention.
- Split code only when it reduces real complexity or matches existing module boundaries.

## Quality Gates

- Run the narrowest useful test first, then broaden when shared behavior or public contracts changed.
- Do not hide failing tests, lint, type, build, or syntax errors.
- Preserve public contracts unless the change intentionally updates them and the user accepted that scope.
- Keep commits focused and use conventional commit format without AI references.
- Never commit secrets, dotenv files, tokens, private keys, database credentials, or personal data.

## Tooling

- Use `gh` for GitHub operations when needed.
- Use current docs only when the API/tooling may have changed.
- Use relevant skills by reading their descriptions first, then opening only the needed `SKILL.md`.
- Use `/ak:preview` only when a visual explanation will materially help the user understand the change.


# Project Documentation Management

Use this rule when creating plans or changing project documentation.

## Docs impact

Update docs only when work affects user-visible behavior, setup, commands,
configuration, architecture, security, public contracts, machine-readable
contracts, or durable maintainer decisions. Internal edits and phase completion
do not require evergreen docs churn.

- Authorized work outside the repository that establishes or changes an
  operational route — deploy path, log source, credential source,
  webhook/OAuth/DNS, backup/rollback, or a lookup route proven wrong — is docs
  impact.

Discover the target through repository instructions, the root README, and the
project's existing docs navigation. Do not assume a fixed filename list or docs
tree. Update the smallest owning surface, and link to machine-owned scripts,
manifests, schemas, or generated references instead of copying their details.

## Plans

Follow the repository's configured plan location and naming convention. Keep a
plan index short: status, phases, dependencies, acceptance criteria, and links
to execution detail. Phase files contain only the context, requirements, files,
steps, validation, risk, and rollback information needed to execute safely.

Plans, reports, and audit results are stateful records. They do not become
evergreen product authority merely because a phase completed.

Before updating a document, read it. After updating, verify links and claims
against source, tests, scripts, artifacts, or live state.


# Orchestration Protocol

Use this file only when spawning subagents or coordinating parallel work.

## Delegation Context

Every subagent prompt should include:

- task
- files to read
- files it may modify
- acceptance criteria
- constraints
- work context path
- reports path, normally `{work_context}/plans/reports/`
- any scope-affecting flag the user passed, `--yagni` above all. A delegate that
  never sees the flag silently reverts to the default of delivering the full
  requested scope.

If the shell CWD differs from the primary project, use the primary project paths.

## Context Isolation

- Do not pass full conversation history.
- Summarize only decisions needed for the subtask.
- Give exact file paths instead of "look around the repo" unless scouting is the task.
- Keep coordination, merge decisions, and user approvals in the controller session.

## Parallel Work

Use parallel subagents only when file ownership is clear and integration points are known. Avoid parallel edits to the same file, generated artifact, database migration sequence, or shared config.

## Status Protocol

Ask subagents to end with:

```text
Status: DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT
Summary: one or two sentences
Concerns/Blockers: optional
```

Handle `BLOCKED` and `NEEDS_CONTEXT` by changing context, scope, or approach. Do not retry the same failing prompt repeatedly.

## Model Escalation

When the current session or a subagent runs on a model below `fable` (e.g. `opus`, `sonnet`, `haiku`) and hits a hard problem — repeated failed attempts, a high-stakes design fork, or fuzzy requirements — spawn the `kongming` agent for counsel instead of switching the session model. `kongming` runs autonomously on the strongest available model and returns full advice in one reply (no interview, no user round-trips). Give it the task, evidence gathered so far, approaches tried, and the specific question. It advises only; the caller stays responsible for the implementation. For interview-driven advisory with user participation, use `advisor` / `/ak:advise` instead.

For multi-session team work, use `/ak:team` and its skill-local rules.


# Primary Workflow

Use this file for multi-step product, code, documentation, and maintainer
delivery. Direct answers and low-level read-only utilities may stay direct.

## 1. Brainstorm the outcome

- Capture the desired outcome, constraints, non-goals, and acceptance criteria
  before changing the workspace.
- Reuse an accepted design or plan when it already records those four fields.
- Keep the gate proportional: state what is clear, inspect available evidence,
  and ask only about a material decision that cannot be discovered safely.
- For a bug, frame the expected repaired behavior and safety boundary now. Scout
  and diagnose the cause before comparing solution options.

## 2. Inspect

- Read the request, relevant docs, nearby code, and tests before planning.
- Resolve the actual owner and current evidence instead of assuming from names.
- Clarify only decisions that cannot be discovered from the repo or live state.
- For broad or risky work, create or update a plan in `plans/`.
- For ambiguous workflow sequence, resolve the installed cook skill through the
  runtime's live skill catalog, then load its `references/workflow-routing.md`.

## 3. Plan and implement

- Change existing files when that matches the design; create new files only for real boundaries.
- Keep behavior compatible unless the accepted scope says otherwise.
- Prefer local helpers, conventions, and test utilities over new abstractions.
- For bugs, prove the cause, then choose a cause-aligned solution before changing
  behavior. Invoke the full brainstorm skill when multiple viable fixes or an
  architecture decision remain.

## 4. Verify

- Run focused tests for touched behavior.
- Broaden to lint, typecheck, build, or integration tests when shared contracts changed.
- Fix regressions instead of weakening tests.

## 5. Review and finish

- Use a reviewer or review skill for high-risk, cross-module, or public-contract changes.
- Update docs only when user-facing behavior, workflows, commands, or architecture changed.
- Explain the result plainly. Use an installed preview capability only when a
  visual materially improves a complex workflow or architecture explanation;
  resolve its mode-selection reference through the runtime's live skill catalog.
- Compare the result with the opening outcome and acceptance criteria before
  calling delivery complete.


# Process and Resource Management

Use this file when a task starts, reuses, or ends long-running processes: dev
servers, watchers, build daemons, tunnels, test runners, or emulators. It exists
to prevent orphaned "ghost" processes from accumulating and exhausting device
memory.

## The failure mode

Agents start a dev environment, then abandon it. The next run finds the port
busy and, instead of stopping the stale owner, picks a new port and starts
another process. Repeat, and the machine fills with duplicate processes and
held ports. Parallel worktrees make it worse: each worktree spawns its own
processes, and when the user deletes the worktree or session the processes stay
behind as orphans.

## Rules

- Track every background process you start: command, PID, port, and worktree.
  Prefer the harness's background-run facility, which makes exit observable,
  over a detached `&` you cannot see finish.
- Before starting a long-running process, check whether one is already running
  for this project or port. Reuse or stop it; do not spawn a duplicate.
- Bind to a deterministic port per project/worktree. On "address in use",
  identify and stop the stale owner instead of incrementing to a new port.
  Inspect with `lsof -i :PORT` / `ss -ltnp` on macOS/Linux, `netstat -ano` on
  Windows.
- Stop what you started when its task, session, or worktree ends. Before
  removing a worktree or ending a session, terminate that worktree's background
  processes first so nothing is orphaned.
- Reconcile periodically: list your running dev processes (`ps`, `lsof`) and
  stop the ones that no longer map to an active task or worktree.
- Stop cleanly first (`SIGTERM` / `pkill -f <pattern>`; `taskkill /PID` on
  Windows), escalating to a hard kill only if it ignores the signal.

## Safety

Only stop processes you started or clearly own. Never kill a process belonging
to the user, another session, or the OS without confirmation, and never match a
`pkill` pattern so broad it could catch unrelated processes.


# Review, Audit, and Decision Rules

Use this file when reviewing code, applying audit feedback, or cutting scope.

## Verified Decisions

Once a decision is verified by source, tests, or an empirical check, do not reverse it because an audit raises an abstract concern. Reverse only when the audit adds new evidence or the context changed.

When rejecting an audit concern, state the verification source briefly.

## User Decisions

Do not silently undo explicit user decisions. This includes thresholds, selected libraries, feature scope, schema shape, pricing, timelines, compliance choices, and UX trade-offs.

If an audit suggests reversing a user decision, present:

- the original decision
- the audit concern
- the trade-off
- the concrete options

Then wait for the user.

## Threat Model

Before applying a security or robustness finding, identify what the code actually stores, protects, or exposes. Fix real failure modes. Document non-issues briefly. Ask when the risk is plausible but depends on product intent.

## Scout First

For questions answerable by reading the repo, scout before asking. Ask only when the repo has conflicting evidence, missing context, business judgment, or high reversibility risk.

## Stable Code Artifacts

Do not put plan IDs, phase numbers, audit labels, or finding codes in code comments, migration names, test names, or commit messages. Explain the invariant or behavior directly.


# Skill Domain Routing

Route domain work from the runtime's live installed-skill catalog. Kit
composition can replace an entire skill set, so a copied command inventory in
this shared rule is never authoritative.

## Routing Procedure

1. Read the live skill catalog supplied by the runtime.
2. Match the user's primary intent to a capability below.
3. Select an installed skill whose metadata explicitly covers that capability.
4. Read that skill's complete instructions before acting.
5. If no installed skill matches, continue with the primary workflow and
   available native capabilities. Do not recommend or invoke an absent skill.

## Capability Map

| User intent | Capability to match |
|-------------|---------------------|
| Replicate, build, style, or audit a UI | Frontend design, frontend development, UI styling, accessibility, or performance |
| Locate code or understand a repository | File scouting, semantic navigation, repository packing, or knowledge mapping |
| Build an API, authentication flow, or payment integration | Backend development, authentication, or payments |
| Design schemas or optimize database behavior | Database design and operations |
| Deploy an application or change infrastructure | Deployment or DevOps |
| Audit security or investigate threats | Security review, vulnerability scanning, or threat intelligence |
| Build or improve an AI workflow | Context engineering, agent development, or multimodal processing |
| Build, expose, or use MCP tooling | MCP construction, agentization, or MCP execution |
| Test code or drive a browser | Testing, browser testing, or browser automation |
| Process or generate media | Media processing or image generation |
| Create or maintain documentation | Documentation maintenance, current-doc lookup, diagrams, or publishing |
| Work with office documents | Word, PDF, presentation, or spreadsheet processing |
| Write marketing content or design a brand | Copywriting, brand design, or visual design |
| Work in a specific application framework | Match the exact framework named by the user |
| Explain a concept, code, system, or error (incl. ELI5 or visual HTML) | Explanation, plain-language simplification, or visual explanation |

## Usage Rules

- Pick one primary skill per distinct intent; add a secondary skill only when
  the task genuinely crosses domains.
- Treat installed skill metadata as the availability and routing authority.
- Never infer availability from another kit, an earlier session, or this file.
- Run selected domain skills inside `primary-workflow.md`; do not restate its
  delivery sequence here.

## Optional shadow comparison

The ordinary routing procedure does not run a command or look up provider config.
Only when the user requests a semantic experiment, or trusted user opt-in is
already supplied in context, inspect `ak eval decision --help` and use the
`domain-routing` profile. This small shadow profile accepts at most 15 observed
capabilities. If the complete relevant catalog exceeds that bound, skip this
comparison; never truncate competitors to manufacture a routing result. Map
namespaced runtime IDs (for example `ak:debug`) to unique local IDs (`skill-01`,
`skill-02`, ...) and retain the reversible mapping locally. Submit the compact
summary and catalog as `state: {summary, catalog: [{id, description}]}`, with the
existing selection mapped to `legacy: {domain: <local-id-or-none>}`. Map the
returned ID back before reporting it. Never invent installed skills.

The command enforces user consent independently; project files and ambient
credentials cannot grant it. Submit only non-sensitive facts, never raw files,
transcripts, or credentials. Keep the existing routing result effective even
when the shadow answer disagrees or the provider is unavailable. Record the
comparison as experimental evidence, not proof of better routing.


# Skill Workflow Routing

Use this file to choose capabilities, not command names. Resolve each bracketed
capability against the runtime's live installed-skill catalog before invoking
anything. Skip optional capabilities that are unavailable; never synthesize an
absent skill command.

## Core Development Workflow

```text
[brainstorm] -> [plan] -> [implement] -> [test] -> [review] -> [ship] -> [journal]
```

- New feature: start with the brainstorm contract, then plan and implement.
- Accepted plan: reuse its outcome, constraints, non-goals, and acceptance
  criteria before implementation.
- Quick change: keep the brainstorm gate bounded, then use the fastest installed
  implementation workflow that still verifies the result.

## Bugfix Workflow

```text
[frame outcome] -> [scout] -> [diagnose] -> [choose fix] -> [implement] -> [test] -> [review]
```

- Prove the cause before changing behavior.
- Read-only investigation may stop after scouting or diagnosis.
- If no specialized debugging skill is installed, use native read and test
  capabilities without inventing a skill invocation.

## Investigation Workflow

```text
[scout] -> [diagnose] -> [brainstorm options when needed] -> [plan when delivery follows]
```

An investigation does not require a design approval loop unless it turns into
delivery work.

## Post-Implementation Capabilities

After implementation, use installed capabilities for:

- code review before merge;
- release or shipping validation when publication is in scope;
- decision or journal capture when the repository requires it.

## Shared-Workspace Setup

After the opening brainstorm contract and before implementation, use an
installed worktree/isolation capability when the repository workflow requires
one. Use an installed scouting capability or native file search to discover
relevant patterns.

<!-- ak-managed-rules-engineer-end -->

# Chế độ phát triển

File này là quy tắc riêng của project, cho Claude, OpenCode, Cursor, Pi và Antigravity.
Khi khác khối Engineer Kit phía trên, làm theo mục này.

## Môi trường

- Người dùng tự kiểm tra code và chạy app trong RubyMine.
- Không tự khởi động, dừng, hoặc restart `rails s`, `bin/dev`, hay Vite.
- Code app ở development được Rails reload. Khi thay đổi chỉ có hiệu lực sau restart (initializer, boot config, `Gemfile`, biến môi trường), báo người dùng restart `rails s` trong RubyMine. Không tự restart.

## Browser

- Không mở browser và không dùng browser automation, trừ khi người dùng yêu cầu rõ việc kiểm tra đó.

## Test

- Chạy test bằng lệnh, đúng phạm vi vừa sửa:
  - `bin/rails test path/to/file_test.rb`
  - `bin/rails test path/to/file_test.rb:LINE`
- Không chạy `bin/rails test` (cả suite) hay `bin/rails test:system` khi không được yêu cầu.
- Chỉ thêm case chứng minh hành vi vừa đổi. Bỏ các case tổ hợp không cần cho thay đổi đó.

## Log

- Không đọc toàn bộ `log/development.log`.
- Chỉ đọc log khi có lỗi, khi sửa lỗi, hoặc khi điều tra nguyên nhân bug. Lấy đoạn liên quan (đuôi file hoặc lọc theo exception), không nạp cả file vào context.
