# Hardening

## Z.ai Integration

O helm delega prompt hardening para o skill `prompt-hardening` já existente na plataforma Z.ai.

Quando o workflow de hardening é acionado (ver `../control-plane/branch-enforcement-matrix.md`):

1. O master agent invoca `Skill(command="prompt-hardening")`
2. O skill analisa a request e produz um prompt hardened
3. O master agent executa o trabalho usando o prompt hardened

## Referência

- Skill nativo: `prompt-hardening` (disponível via Skill tool no Z.ai)
- Gate de hardening: quando a classificação identifica uma request como "ambiguous",
  o fluxo é desviado para hardening ANTES de qualquer execução

## Conceito Original

O accelerate define hardening como um gate que bloqueia execução até que o prompt
esteja claro o suficiente. Este conceito é preservado integralmente no helm — a
implementação é via skill nativo do Z.ai em vez de módulo próprio do accelerate.

### Gate Flow

```
Request classificada como "ambiguous"
  → Skill(command="prompt-hardening") invocado
  → Prompt hardened retornado
  → Request re-classificada com prompt claro
  → Execução prossegue na branch correta
```

## Diferença do accelerate

| Aspecto | accelerate | helm (Z.ai) |
|---|---|---|
| Implementação | Módulo próprio `core/hardening/prompt-hardening.md` | Skill nativo `prompt-hardening` via Skill tool |
| Invocação | Referência no SKILL.md como lei constitucional | Invocação via `Skill(command="prompt-hardening")` |
| Output | Prompt hardened no contexto da sessão | Prompt hardened retornado ao master agent |
