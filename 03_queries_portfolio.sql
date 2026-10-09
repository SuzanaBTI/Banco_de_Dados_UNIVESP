-- ============================================================================
-- PROJETO PORTFÓLIO SQL: CONCILIAÇÃO FINANCEIRA E ANÁLISE DE CHARGEBACKS
-- ============================================================================
-- Descrição: Script com consultas analíticas avançadas para conciliação financeira,
-- auditoria de sistemas legados (Vision/Reflection) e gestão de risco de bandeiras.
-- Autor: Portfólio de Engenharia e Análise de Dados
-- ============================================================================

USE `fintech_chargebacks`;

-- ----------------------------------------------------------------------------
-- QUERY 1: Monitoramento de SLA (120 Dias) para Defesa de Chargebacks
-- Objetivo: Identificar disputas em aberto que se aproximam do prazo limite
-- de 120 dias imposto pelas bandeiras (Visa/Mastercard), priorizando ações.
-- ----------------------------------------------------------------------------
SELECT 
    c.reference_number_arn AS arn,
    t.cartao_mascarado,
    e.nome_estabelecimento,
    t.adquirente,
    t.bandeira,
    c.data_contestacao,
    DATEDIFF(CURRENT_DATE, c.data_contestacao) AS dias_decorridos_sla,
    c.status_bandeira,
    CASE 
        WHEN DATEDIFF(CURRENT_DATE, c.data_contestacao) > 100 THEN 'CRÍTICO - Risco de Perda'
        WHEN DATEDIFF(CURRENT_DATE, c.data_contestacao) BETWEEN 60 AND 100 THEN 'ALERTA - Em Acompanhamento'
        ELSE 'DENTRO DO PRAZO'
    END AS status_sla
FROM contestacoes_chargeback c
JOIN transacoes t ON c.id_transacao = t.id_transacao
JOIN estabelecimentos e ON t.id_estabelecimento = e.id_estabelecimento
WHERE c.status_bandeira NOT IN ('Encerrada', 'Deferido')
ORDER BY dias_decorridos_sla DESC;


-- ----------------------------------------------------------------------------
-- QUERY 2: Auditoria de Batimento entre Sistemas (Vision/Reflection vs Portal Bandeira)
-- Objetivo: Detectar divergências operacionais onde a bandeira finalizou o processo,
-- mas o sistema legado interno ainda consta como 'Pendente' ou 'Sem Lançamento'.
-- ----------------------------------------------------------------------------
SELECT 
    c.reference_number_arn AS arn,
    e.nome_estabelecimento,
    t.adquirente,
    c.status_bandeira AS status_portal_bandeira,
    c.status_vision AS status_sistema_vision,
    c.valor_parcela_contestada,
    'Ação Necessária: Baixa Manual / Ajuste de Integração' AS recomendacao_auditoria
FROM contestacoes_chargeback c
JOIN transacoes t ON c.id_transacao = t.id_transacao
JOIN estabelecimentos e ON t.id_estabelecimento = e.id_estabelecimento
WHERE c.status_bandeira IN ('Encerrada', 'Deferido')
  AND c.status_vision IN ('Pendente', 'Sem Lançamento', 'Aguardando Baixa');


-- ----------------------------------------------------------------------------
-- QUERY 3: Conciliação Financeira de Repasses e Emissão Automática de Vouchers
-- Objetivo: Comparar o valor em disputa com o valor efetivamente creditado pela
-- Adquirente (Cielo/Stone/Rede/Getnet) para identificar inconsistências financeiras.
-- ----------------------------------------------------------------------------
SELECT 
    c.reference_number_arn AS arn,
    e.nome_estabelecimento,
    t.adquirente,
    c.valor_parcela_contestada,
    c.valor_creditado_adquirente,
    ROUND(c.valor_parcela_contestada - c.valor_creditado_adquirente, 2) AS diferenca_voucher,
    CASE 
        WHEN c.valor_creditado_adquirente = 0 THEN 'Pendente Repasse'
        WHEN c.valor_parcela_contestada = c.valor_creditado_adquirente THEN 'Conciliado OK'
        WHEN c.valor_creditado_adquirente < c.valor_parcela_contestada THEN 'Cobrar Voucher Adquirente'
        ELSE 'Ajuste Débito a Maior'
    END AS status_conciliacao
FROM contestacoes_chargeback c
JOIN transacoes t ON c.id_transacao = t.id_transacao
JOIN estabelecimentos e ON t.id_estabelecimento = e.id_estabelecimento
WHERE c.status_bandeira = 'Encerrada'
ORDER BY diferenca_voucher DESC;


-- ----------------------------------------------------------------------------
-- QUERY 4: Painel Executivo de Risco de Fraude por Estabelecimento
-- Objetivo: Consolidar volume financeiro em disputa, proporção de fraudes vs
-- controvérsias e classificar o risco do comerciante para prevenção de perdas.
-- ----------------------------------------------------------------------------
SELECT 
    e.nome_estabelecimento,
    e.risco_fraude AS risco_cadastral,
    COUNT(c.reference_number_arn) AS total_contestacoes,
    SUM(CASE WHEN c.tipo_contestacao = 'Fraude' THEN 1 ELSE 0 END) AS qtd_fraudes,
    SUM(CASE WHEN c.tipo_contestacao = 'Controvérsia' THEN 1 ELSE 0 END) AS qtd_controversias,
    ROUND(SUM(c.valor_parcela_contestada), 2) AS valor_total_em_disputa,
    ROUND(SUM(c.valor_creditado_adquirente), 2) AS valor_total_recuperado
FROM estabelecimentos e
JOIN transacoes t ON e.id_estabelecimento = t.id_estabelecimento
JOIN contestacoes_chargeback c ON t.id_transacao = c.id_transacao
GROUP BY e.nome_estabelecimento, e.risco_fraude
ORDER BY valor_total_em_disputa DESC;
