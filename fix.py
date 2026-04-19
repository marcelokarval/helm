import re

# Fix branch-enforcement-matrix.md
filepath = "/tmp/helm/core/control-plane/branch-enforcement-matrix.md"
with open(filepath, 'r') as f:
    content = f.read()

# 1. Fix the broken command lines (lines 59-64)
content = content.replace(
    "- backend schema/runtime slice\n  - `uv run python backend/src/bun run lint`\n  - `uv run python backend/src/bun run db:push --check --dry-run`\n  - `uv run python backend/src/bun/prisma migrate --check`\n- frontend TypeScript/runtime slice\n  - `npm run bun run lint --prefix frontends/front-react`",
    "- backend schema/runtime slice\n  - `bun run lint`\n  - `bun run db:push`\n- frontend TypeScript/runtime slice\n  - `bun run lint`"
)

# 2. Fix the outdated command descriptions (lines 70-78)
content = content.replace(
    "- `check`\n  - Next.js system/config/runtime checks\n- `makemigrations --check --dry-run`\n  - model drift without a generated migration\n- `migrate --check`\n  - unapplied migrations already present in the codebase\n\nIf a run closes with only `check` after backend schema/runtime work, treat that\nas a validation failure.",
    "- `bun run lint`\n  - Next.js system/config/runtime checks\n- `bun run db:push`\n  - schema drift without a pushed migration\n\nIf a run closes with only `bun run lint` after backend schema/runtime work, treat that\nas a validation failure."
)

# 3. Fix linear-implementation-planner
content = content.replace(
    "docs/TASKS.md + worklog.md; `linear-implementation-planner`",
    "docs/TASKS.md + worklog.md; `task-implementation-planner`"
)

# 4. Fix bare "AI Review" (shorthand, not "AI Review Report" which was already replaced)
content = content.replace(
    "commit trail + AI Review |",
    "commit trail + worklog.md Stage Summary |"
)

with open(filepath, 'w') as f:
    f.write(content)
print(f"Fixed {filepath}")

# Fix issue-driven-mutation-stack.md
filepath2 = "/tmp/helm/core/issue-topology/issue-driven-mutation-stack.md"
with open(filepath2, 'r') as f:
    content2 = f.read()

# Fix linear-implementation-planner
content2 = content2.replace(
    "`linear-implementation-planner`",
    "`task-implementation-planner`"
)

# Fix linear-progress-reporter
content2 = content2.replace(
    "`linear-progress-reporter`",
    "`worklog-updater`"
)

with open(filepath2, 'w') as f:
    f.write(content2)
print(f"Fixed {filepath2}")

print("Done fixing.")
