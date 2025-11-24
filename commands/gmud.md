# Generate GMUD Documentation

Generate complete change management documentation for ServiceNow GMUD Planejada form.

Based on context provided, create all required fields matching the form structure.

IMPORTANT: Use bullet points with hyphens (-) for all lists. Do NOT number items.

## Output Format

**CAMPOS PRINCIPAIS:**

Título da mudança: [Max 150 chars]

Subcategoria: [Infra/Aplicação/etc]

Descrição detalhada:
[O que será mudado - detalhado]

Descrição / Justificativa:
[Por que é necessário]

Detalhamento técnico:
- PR: [número]
- Link: [URL]
- Versão atual: [x.x.x]
- Versão destino: [x.x.x]
- Componentes: [lista]

Impacto Senso: [Descrição do impacto]

Justifica: [Dropdown - código de infraestrutura]

Análise de indisponibilidade / intermitência:
[Haverá indisponibilidade? Quanto tempo? Quais sistemas?]

---

**PLANEJAMENTO:**

Plano de implementação:
- [Passo detalhado]
- [Passo detalhado]
- [Passo detalhado]

Responsáveis pelas atividades:
[Nome/time responsável]

Plano de retorno (Rollback):
- [Passo de reversão]
- [Passo de reversão]
- [Passo de reversão]

Responsáveis pelo plano de retorno:
[Nome/time responsável]

Plano de teste pós-implementação:
- [Validação]
- [Validação]
- [Validação]

Responsáveis pelas testes pós-implementação:
[Nome/time responsável]

---

**PROGRAMAÇÃO:**

Data planejada de início: [DD/MM/AAAA HH:mm:ss]

Data de término planejada: [DD/MM/AAAA HH:mm:ss]

Data do Comitê de Mudanças: [DD/MM/AAAA HH:mm:ss]

CAB Manager: [Nome]

---

**ANÁLISE DE PRIORIDADE:**

Gravidade: [Baixa/Média/Alta]

Urgência: [Baixa/Média/Alta]

Impacto: [Baixo/Médio/Alto]

---

**ANÁLISE DE RISCO:**

Risco: [Baixo/Médio/Alto/Muito Alto]

Impacto: [Baixo/Médio/Alto]

Probabilidade: [Baixa/Média/Alta]

---

**TERMOS DA MUDANÇA:**

[Informações sobre SLA, acordos, etc]

---

**ANÁLISE DA MUDANÇA:**

Em caso de falha, qual problema seria gerado em produção? Erro? Parada?
[Resposta]

O que motiva abrir essa mudança? Justifique:
[Resposta]

Está correto? Alguma coisa pode dar errado? É a solução certa?
[Resposta]

Houve alinhamento com as pessoas envolvidas, tanto TI quanto negócio?
[Resposta]

Qual item de configuração que sofrerá alteração? (BKS, API, Lambdas, ETC)
[Resposta]

---

**TASKS (Para adicionar via modal "Adicionar Linha"):**

PRÉ-MUDANÇA:
Título: Validações pré-mudança
Descrição da Tarefa:
- [ ] Validar backups
- [ ] Revisar PRs
- [ ] [Outras validações]
Data início: [DD/MM/AAAA HH:mm:ss]
Data término: [DD/MM/AAAA HH:mm:ss]
Descrição do Rollback:
- [ ] [Passos para reverter as validações, se aplicável]
Grupo: [DO/NM/AAA HH:mm:ss]
Ordem: 1

EXECUÇÃO:
Título: Execução da mudança
Descrição da Tarefa:
- [ ] [Passos de execução]
Data início: [DD/MM/AAAA HH:mm:ss]
Data término: [DD/MM/AAAA HH:mm:ss]
Descrição do Rollback:
- [ ] [Passos para reverter a execução]
Grupo: [DO/NM/AAA HH:mm:ss]
Ordem: 2

PÓS-MUDANÇA:
Título: Validações pós-mudança
Descrição da Tarefa:
- [ ] [Validações]
Data início: [DD/MM/AAAA HH:mm:ss]
Data término: [DD/MM/AAAA HH:mm:ss]
Descrição do Rollback:
- [ ] [Não aplicável - validações não requerem rollback]
Grupo: [DO/NM/AAA HH:mm:ss]
Ordem: 3

ROLLBACK:
Título: Plano de rollback (se necessário)
Descrição da Tarefa:
- [ ] [Passos de rollback completo]
Data início: [DD/MM/AAAA HH:mm:ss]
Data término: [DD/MM/AAAA HH:mm:ss]
Descrição do Rollback:
- [ ] [Esta É a tarefa de rollback - reverter para estado anterior]
Grupo: [DO/NM/AAA HH:mm:ss]
Ordem: 4

---

Generate complete content for all fields using bullet points with hyphens for lists. Ask user for context if needed.
