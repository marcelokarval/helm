# Fix remaining lowercase instances that map to the same concepts

filepath = "/tmp/helm/core/delegation/subagent-model.md"
with open(filepath, 'r') as f:
    content = f.read()

# "implementation worker" (lowercase) maps to same concept as "Implementation Worker"
content = content.replace(
    "- implementation worker",
    "- full-stack-developer subagent",
    1  # only first occurrence (in Safe Role Catalog)
)

# "governance auditor" (lowercase) maps to same concept as "Governance Auditor"
content = content.replace(
    "- governance auditor",
    "- Plan subagent",
    1  # only first occurrence (in Safe Role Catalog)
)

# "spawn an implementation worker" in Spawn Criteria section
content = content.replace(
    "spawn an implementation worker",
    "spawn a full-stack-developer subagent"
)

with open(filepath, 'w') as f:
    f.write(content)
print(f"Fixed {filepath}: +3 substitutions")
