import re
import os

def count_and_replace(content, old, new):
    """Count occurrences and replace. Returns (new_content, count)."""
    count = content.count(old)
    if count > 0:
        content = content.replace(old, new)
    return content, count

def process_file(content, filepath):
    """Apply all systematic substitutions. Returns (new_content, total_count)."""
    total = 0
    
    # Define substitutions in careful order (most specific/longest first)
    # This prevents partial matches from eating longer patterns
    
    # === Multi-word / compound substitutions (LONGEST FIRST) ===
    
    multi_word = [
        # Claude/Codex family
        ("Claude/Codex", "Z.ai"),
        ("Codex-native", "Z.ai-native"),
        ("always-on root", "description-based enforcement"),
        
        # Issue tracker / workflow
        ("GitHub Issues", "docs/TASKS.md"),
        ("active workflow adapter", "docs/TASKS.md + worklog.md"),
        ("workflow adapter stack", "docs/ task tracking system"),
        
        # Path substitutions (most specific first)
        ("~/.codex/skills/accelerate", "skills/helm/"),
        (".claude/napkin.md", "worklog.md"),
        (".accelerate/", "docs/helm/"),
        (".claude/", "skills/helm/"),
        ("workspace.toml", "docs/helm/config.md"),
        
        # Agent/persona names (full names first)
        ("Implementation Worker", "full-stack-developer subagent"),
        ("Governance Auditor", "Plan subagent"),
        ("Specification PM", "prompt-hardening skill"),
        ("Product Planner", "Plan subagent"),
        ("Delivery PM", "master agent"),
        
        # Promoted agent / agent promotion
        ("promoted agent", "subagent type selection"),
        ("agent promotion", "skill creation/update (human-directed)"),
        
        # toml patterns (longer first)
        ("*.toml agents", "5 subagentes via Task tool"),
        
        # Tool chains
        ("Chrome DevTools", "agent-browser"),
        ("EXPLAIN (PostgreSQL)", "N/A (SQLite)"),
        ("AI Review Report", "worklog.md Stage Summary"),
        ("Figma artifact", "ascii-wireframe output"),
        ("Stitch", "ascii-wireframe"),
        ("Django ORM", "Prisma ORM"),
        ("Python/uv", "bun/Next.js"),
        ("python-uv", "bun-nextjs"),
        
        # manage.py patterns (longer first to avoid partial)
        ("manage.py check", "bun run lint"),
        ("manage.py makemigrations", "bun run db:push"),
        ("manage.py", "bun/prisma"),
        
        # Move issue patterns
        ("move the issue to ", "update docs/TASKS.md to "),
        ("move an issue to ", "update docs/TASKS.md to "),
    ]
    
    for old, new in multi_word:
        content, c = count_and_replace(content, old, new)
        total += c
        if c > 0:
            print(f"  [{c}x] '{old}' -> '{new}'")
    
    # === Single-word substitutions ===
    single_word = [
        ("Claude", "Z.ai agent"),
        ("Codex", "Z.ai"),
        ("Linear", "docs/TASKS.md"),
        ("Playwright", "agent-browser"),
        ("Django", "Next.js"),
        ("type-check", "bun run lint"),
        ("*.toml", "subagent types"),
        ("always-on", "description-based enforcement"),
        ("EXPLAIN", "N/A (SQLite)"),
    ]
    
    for old, new in single_word:
        content, c = count_and_replace(content, old, new)
        total += c
        if c > 0:
            print(f"  [{c}x] '{old}' -> '{new}'")
    
    # === Lowercase claude/codex (word-boundary aware) ===
    for pattern, replacement in [("claude", "Z.ai"), ("codex", "Z.ai")]:
        matches = list(re.finditer(r'\b' + pattern + r'\b', content))
        c = len(matches)
        if c > 0:
            content = re.sub(r'\b' + pattern + r'\b', replacement, content)
            total += c
            print(f"  [{c}x] '\\b{pattern}\\b' -> '{replacement}'")
    
    # === accelerate/helm substitution ===
    # Must protect URLs like github.com/marcelokarval/accelerate
    # Strategy: find all accelerate occurrences, skip those in URLs, replace rest
    
    # First, let's find and protect URL occurrences
    url_pattern = r'github\.com/[^/\s]*/accelerate'
    url_matches = list(re.finditer(url_pattern, content))
    
    # Find all 'accelerate' occurrences (case sensitive for now)
    accel_matches = list(re.finditer(r'accelerate', content))
    
    accel_count = 0
    for m in reversed(accel_matches):  # reverse to preserve positions
        start, end = m.start(), m.end()
        # Check if this is inside a URL
        in_url = False
        for um in url_matches:
            if um.start() <= start and end <= um.end():
                in_url = True
                break
        if not in_url:
            # Check surrounding context for capitalization
            # If preceded by uppercase context or at start of sentence
            # Actually let's check the character before
            if start > 0 and content[start-1].isupper():
                # "Accelerate" context - but actually this is rare
                # The word itself is lowercase in all files
                content = content[:start] + "helm" + content[end:]
            else:
                content = content[:start] + "helm" + content[end:]
            accel_count += 1
    
    # Now handle "Accelerate" (capitalized) - not in URLs
    accel_cap_matches = list(re.finditer(r'Accelerate', content))
    for m in reversed(accel_cap_matches):
        start, end = m.start(), m.end()
        in_url = False
        for um in url_matches:
            if um.start() <= start and end <= um.end():
                in_url = True
                break
        if not in_url:
            content = content[:start] + "Helm" + content[end:]
            accel_count += 1
    
    if accel_count > 0:
        total += accel_count
        print(f"  [{accel_count}x] 'accelerate' -> 'helm' (non-URL)")
    
    return content, total

def main():
    files = [
        "/tmp/helm/core/README.md",
        "/tmp/helm/core/control-plane/branch-enforcement-matrix.md",
        "/tmp/helm/core/delegation/subagent-model.md",
        "/tmp/helm/core/hardening/prompt-hardening.md",
        "/tmp/helm/core/issue-topology/issue-driven-mutation-stack.md",
        "/tmp/helm/core/lanes/README.md",
        "/tmp/helm/core/lanes/manager-lane-model.md",
    ]
    
    grand_total = 0
    results = []
    
    for filepath in files:
        orig_path = filepath + ".orig"
        if not os.path.exists(orig_path):
            print(f"SKIP: {orig_path} not found")
            continue
        
        with open(orig_path, 'r') as f:
            content = f.read()
        
        print(f"\n{'='*60}")
        print(f"Processing: {filepath}")
        print(f"{'='*60}")
        
        new_content, count = process_file(content, filepath)
        
        with open(filepath, 'w') as f:
            f.write(new_content)
        
        grand_total += count
        results.append((filepath, count))
        print(f"  TOTAL substitutions: {count}")
    
    print(f"\n{'='*60}")
    print(f"SUMMARY")
    print(f"{'='*60}")
    for filepath, count in results:
        print(f"  {filepath}: {count} substitutions")
    print(f"\n  GRAND TOTAL: {grand_total} substitutions across {len(results)} files")

if __name__ == "__main__":
    main()
