// ==========================================
// EXERCÍCIO MONGODB - AGGREGATION FRAMEWORK
// ==========================================

// 1. Inserindo documentos na coleção (Estrutura de Documentos / Schemaless)
db.eventos.insertMany([
  {
    "nome": "Simpósio de Tecnologia e Dados",
    "sigla": "STD",
    "edicao": "2ª Edição",
    "area_concentracao": "Tecnologia da Informação",
    "idiomas_aceitos": ["Português", "Inglês"],
    "participantes_estimados": 450
  },
  {
    "nome": "Congresso de Inteligência Artificial",
    "sigla": "CIA",
    "edicao": "1ª Edição",
    "area_concentracao": "Tecnologia da Informação",
    "idiomas_aceitos": ["Inglês", "Espanhol"],
    "participantes_estimados": 1200
  }
]);

// 2. Criando um Pipeline de Agregação (Esteira de Dados - Match, Group, Sort, Project)
db.eventos.aggregate([
  // Estágio 1: Filtra apenas eventos da área de TI
  {
    $match: { "area_concentracao": "Tecnologia da Informação" }
  },
  
  // Estágio 2: Agrupa por área e calcula o total de participantes e a média
  {
    $group: {
      _id: "$area_concentracao",
      total_participantes: { $sum: "$participantes_estimados" },
      media_participantes: { $avg: "$participantes_estimados" }
    }
  },
  
  // Estágio 3: Projeta/Formata a saída dos campos na tela
  {
    $project: {
      _id: 0,
      area: "$_id",
      totalGeral: "$total_participantes",
      mediaPorEvento: "$media_participantes"
    }
  },
  
  // Estágio 4: Ordena de forma decrescente pelo total geral
  {
    $sort: { totalGeral: -1 }
  }
]);
