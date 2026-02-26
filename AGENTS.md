# Claude Instructions for Canva Development

## Development Workflow

**Quick reference for the standard development cycle:**

1. Create branch with proper naming convention
2. Make changes
3. Run `taz check` to validate (format, lint, test)
4. Commit with proper message format
5. Find reviewers: `tools/code_review/ownership reviewers`
6. Submit PR: `taz submit` with flags (see PR Submission below)

---

## Git Conventions

### Branch Naming

**Philosophy:** Branch names are identifiers, not documentation. The PR title and description carry the context.

**Format:**
- Single PR: `thomashexton-<JIRA-TICKET>`
- PR train: `thomashexton-<JIRA-TICKET>-<number>`
- No ticket: `thomashexton-<brief-description>`

**Use uppercase for Jira board to match Jira's format (e.g., ADDV-59).**

```bash
# Single PR for a ticket
git checkout -b thomashexton-ADDV-59

# PR train (stacked PRs for same ticket)
git checkout -b thomashexton-ADDV-59-1
git checkout -b thomashexton-ADDV-59-2
git checkout -b thomashexton-ADDV-59-3

# No ticket (minor changes)
git checkout -b thomashexton-fix-header-typo
git checkout -b thomashexton-update-dependencies
```

### Commit Messages

Start with JIRA ticket (uppercase board, no colon):

```bash
# With ticket
git commit -m "ADDV-59 Fix authentication validation"

# Without ticket
git commit -m "Update test dependencies"
```

**Note:** Write your first commit with care - it often becomes the PR title.

### Pull Request Descriptions

**Philosophy:** A PR should solve one explicit thing, describable in 1-2 sentences.

**PR Title format:** `JIRA-123 Verb description`
- Use action verbs: Add, Fix, Update, Remove, Refactor
- Keep concise and descriptive

**PR Description template:**
```markdown
## Problem
[1-2 sentences: What's broken, missing, or needed?]

## Solution
[Describe the approach and why this solution was chosen]

## Context
- **JIRA:** [TICKET-123](link)
- **Figma:** [Design link] (if applicable)
- **Confluence:** [PRD/spec link] (if applicable)
- **Related PRs:** #123 (if applicable)

## Screenshots/Video
[For UI changes: visual proof of changes]
```

---

## Canva Tools

### otter - Infrastructure Integration Tool

`otter` is Canva's infrastructure tool that connects AI coding assistants to internal services. It provides access to 90+ MCP tools for GitHub, Jira, Buildkite, Confluence, RMS, Release Engine, and more. Run `otter --help` to see the full command list.

**Key commands:**
- `otter claude-code` - Launch Claude Code CLI
- `otter mcp list` - See all available MCP tools
- `otter mcp exec <tool>` - Execute a specific MCP tool
- `otter skill list` - List available skills
- `otter kb search <query>` - Search knowledge bases
- `otter feed -a <file>` - Quick AI analysis of code/files

**Note:** Most MCP tools are automatically available in Claude Code as skills (e.g., `jira-get-issue`, `get-pull-request`, `kb-search`). You don't usually need to call `otter` directly - Claude uses these tools automatically.

### taz - Main Developer Tool

`taz` is **THE** primary developer workflow tool at Canva. **Use this proactively and frequently** during all development tasks. Run `taz --help` to see the full command list.

**Code quality (run before commits):**
- `taz check` - Runs generate, format, lint, and test in one command
- `taz check --fix` - Same as above but auto-fixes lint issues
- `taz format` - Format code only
- `taz lint --fix` - Lint with auto-fix
- `taz generate` / `taz g` - Code generation

**PR & CI workflow:**
- `taz submit` - Submit PR (see PR Submission section — requires flags in agent context)
- `taz status` - Check the status of your change/PR
- `taz trigger-ci` / `taz ci` - Kick off a CI run on your branch
- `taz merge` - Merge a pull request

**Utilities:**
- `taz what-changed` - List modified files (`--show-status` for A/M/D labels)
- `taz devbox` - Manage devboxes (create, stop, list, connect via Cursor/IJ/VSCode)

**Tips:**
- `--since <commit-ish>` on check/format/lint scopes to files changed since that ref
- `--tui=false` disables TUI on any command (auto-disabled in non-TTY environments)

### PR Submission

**Primary method — Otter MCP GitHub tools:**

Otter's MCP tools are purpose-built for agent/devbox use — auto-managed tokens (mTLS), no interactive prompts, and available as native Claude Code skills:
- `list-pull-requests` - **Always check for existing PRs before creating** (filter by `head` branch)
- `create-pull-request` - Create a PR (only after confirming none exists for the branch)
- `update-pull-request` - Update PR title/body/reviewers
- `push-files` - Push files to a branch remotely
- `create-branch` - Create a branch remotely
- `merge-pull-request` - Merge a PR
- `get-pull-request-status` - Check PR CI/review status
- `request-copilot-review` - Request automated code review

**Important:**
- Before creating a PR, always check if one already exists for the current branch. If it does, use `update-pull-request` instead of `create-pull-request`.
- When pushing new commits to an existing PR, do NOT replace the PR title or description — the original was crafted intentionally. If the scope evolved, **append** to the existing description rather than rewriting it. Only update if explicitly asked.

**Fallback — `taz submit` with flags (non-interactive):**

`taz submit` without arguments defaults to interactive mode (editor + TUI), which fails in agent contexts. If using taz, always pass flags:

```bash
taz submit --no-edit \
  --title "ADDV-59 Fix authentication validation" \
  --reviewers "reviewer1,reviewer2" \
  --summary "Description of changes" \
  --test-plan "How this was tested"
```

- `--no-edit` skips the interactive editor (required for agent/non-interactive use)
- Pushes the branch, creates a draft PR, and assigns reviewers in one command
- Use `--publish` to skip draft state if needed

**Do NOT use `gh` CLI** — neither `taz` nor `otter` depend on it. `gh` requires interactive `gh auth login` which doesn't work in agent/devbox contexts.

### ownership - Code Review Tool

`tools/code_review/ownership` is Canva's code ownership system for finding reviewers. Run `tools/code_review/ownership --help` for full options.

**Key commands:**
- `tools/code_review/ownership reviewers` - Find PR reviewers
- `tools/code_review/ownership whoami` - Check your identity
- `tools/code_review/ownership whois <email>` - Find GitHub username
- `tools/code_review/ownership list <path>` - See who owns specific code

**When to use:**
- Run `ownership reviewers` to find appropriate reviewers for your PR
  - **Note:** Consider reviewer workload (current PR count) when assigning - visible in GitHub UI
- Use `ownership list` to understand who owns code you're modifying
- Use `ownership whois` to find GitHub usernames from emails

### Proto Regeneration Tool

`bin/regen_protos.sh` regenerates protobuf files from proto definitions. Run `bin/regen_protos.sh --help` for full options.

**Key commands:**
- `bin/regen_protos.sh -i <service_name>` - Regenerate protos for specific service (recommended)
- `bin/regen_protos.sh` - Regenerate all protos

**When to use:**
- After modifying `.proto` files in `protos/src/main/proto/services/`
- Use `-i <service_name>` to regenerate only protos for a specific service

**Note:** Do not manually edit generated files marked with `@Generated("com.canva.protogen")`

---

## Running Tests

**Common patterns:**
```bash
# All tests in a service
bazel test //<service>:all

# Filter by type
bazel test //<service>:all --test_tag_filters=unit
bazel test //<service>:all --test_tag_filters=integration

# Specific test class
bazel test //<target> --test_filter="TestClassName"
```

**Finding targets:** Check BUILD.bazel files or run `bazel query --help` for discovery options

---

## Service-Specific Notes

<!-- Placeholder: Add service-specific workflows, gotchas, or patterns as they emerge -->

**Currently:** No specific service focus (team transition in progress)

**Examples of what might go here:**
- Common patterns for a service you work on frequently
- Known gotchas or edge cases
- Service-specific testing approaches
- Investigation summaries for complex flows

---

## Meta: Improving These Instructions

**This file should evolve with my workflow.** If you notice any of the following, suggest adding it to this file:

- I correct or override an instruction here more than once
- I repeatedly give you the same context or correction
- A pattern emerges in how I prefer to work that isn't documented
- We discover a convention that would prevent repeated mistakes

When suggesting improvements, ask me first before editing `~/.claude/CLAUDE.md`.

### TODO: Investigations

**Dynamic Jira Context Detection:**
- Instead of hardcoding Jira board (e.g., "ADDV") in git conventions, investigate if Claude can dynamically detect:
  - Current Jira board from ticket context (when conversation starts with a ticket URL)
  - Use Jira MCP to query and extract board prefix automatically
  - Make this config more shareable across teams
- Question: Is this a good use case for "personal knowledge base" pattern, or should it be skill/MCP-driven?
- Goal: Make dotfiles more universal and shareable without hardcoded team-specific info
