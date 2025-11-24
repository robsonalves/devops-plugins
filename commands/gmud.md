# Generate GMUD Documentation

Generate complete change management documentation for ServiceNow GMUD Planejada form.

Based on context provided, create all required fields matching the form structure.

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
[Passos detalhados de execução]

Responsáveis pelas atividades:
[Nome/time responsável]

Plano de retorno (Rollback):
[Passos detalhados de reversão]

Responsáveis pelo plano de retorno:
[Nome/time responsável]

Plano de teste pós-implementação:
[Como validar que funcionou]

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
Data início: [DD/MM/AAAA HH:mm:ss]
Data término: [DD/MM/AAAA HH:mm:ss]
Grupo: [DO/NM/AAA HH:mm:ss]
Ordem: 1
- [ ] Validar backups
- [ ] Revisar PRs
- [ ] [Outras validações]

EXECUÇÃO:
Título: Execução da mudança
Data início: [DD/MM/AAAA HH:mm:ss]
Data término: [DD/MM/AAAA HH:mm:ss]
Grupo: [DO/NM/AAA HH:mm:ss]
Ordem: 2
- [ ] [Passos de execução]

PÓS-MUDANÇA:
Título: Validações pós-mudança
Data início: [DD/MM/AAAA HH:mm:ss]
Data término: [DD/MM/AAAA HH:mm:ss]
Grupo: [DO/NM/AAA HH:mm:ss]
Ordem: 3
- [ ] [Validações]

ROLLBACK:
Título: Plano de rollback
Data início: [DD/MM/AAAA HH:mm:ss]
Data término: [DD/MM/AAAA HH:mm:ss]
Grupo: [DO/NM/AAA HH:mm:ss]
Ordem: 4
- [ ] [Passos de rollback]

---

Generate complete content for all fields. Ask user for context if needed.
