# Backlog do App de Academia (Flutter Local-First)

## 1. Infraestrutura e Base Local
- [x] Configurar projeto Flutter e arquitetura (Clean Architecture).
- [x] Configurar banco de dados local (`Isar` ou `Drift`).
- [x] Implementar repositórios de dados (Treinos, Exercícios, Histórico, Métricas).
- [x] Configurar gerência de estado local (Riverpod ou Bloc).

## 2. Gestão de Exercícios e Seed
- [x] Criar tela de listagem de exercícios com busca e filtros por grupo muscular.
- [x] Implementar Seed Inicial: carregar JSON de exercícios básicos na primeira instalação.
- [x] Importação/Exportação JSON: permitir backup e adição de treinos/exercícios.
- [ ] Suporte a mídia local (GIFs/Vídeos curtos) empacotados ou importados da galeria. _(parcial: GIF/imagem importados da galeria; vídeo e mídia empacotada não feitos)_

## 3. Execução do Treino (Workout Tracker)
- [x] Criar interface de "Treino Ativo" (Dark Mode, UI para uma mão).
- [x] Implementar Timers (Segundo Plano + Notificações Locais):
  - [x] Cronômetro Global (tempo total).
  - [x] Timer de Descanso entre séries e entre exercícios.
- [x] Registro dinâmico de Cargas e Repetições.
- [x] Salvar consolidação do treino no histórico local.

## 4. Evolução Corporal e Gráficos
- [x] Criar formulário de input de métricas (Peso, Altura, medidas detalhadas, % gordura).
- [x] Cálculo automático e histórico de IMC.
- [x] Dashboard com `fl_chart` para métricas corporais.

## 5. Planejador Inteligente (Otimizador STRIPS Local)
- [x] Modelar a estrutura STRIPS em Dart (execução via *Isolate*):
  - [x] **Estado Inicial:** Fadiga e balanço de volume dos últimos 7 a 30 dias.
  - [x] **Objetivo:** Equilíbrio ótimo de volume entre todos os grupos musculares.
  - [x] **Efeitos:** Atualizar fadiga e balanço após cada treino real.
- [x] Implementar re-cálculo silencioso para adaptação a faltas/desvios.
- [x] **Estratégia de Adaptação Dinâmica:** O algoritmo deve avaliar o custo-benefício de manter o grupo muscular focado e substituir exercícios incompatíveis X trocar o grupo muscular inteiro do dia para manter o equilíbrio semanal/mensal.
- [x] Criar UI de "Treino Sugerido": exibir Grupos Musculares do dia + Lista de Exercícios.

## 6. Gestão de Locais e Equipamentos (Context-Aware)
- [x] Criar entidade de banco de dados para `Equipamento`. A modelagem deve ser **altamente granular** (ex: Halteres até 10kg, Halteres até 30kg, Leg Press 45, Leg Press 90, Barra Olímpica 20kg).
- [x] Atualizar entidade `Exercicio` para conter uma lista estrita de `Equipamentos Necessários`.
- [x] Criar CRUD para `Academia / Local`:
  - [x] Nome e Coordenadas GPS (Lat/Long).
  - [x] Raio de tolerância (ex: 100 metros).
  - [x] Check-list dos equipamentos granulares disponíveis.
- [x] Implementar serviço de Localização GPS (Foreground) no carregamento do app.
- [x] Integrar Localização com o Otimizador:
  - [x] **Filtro de Viabilidade:** Eliminar ações (exercícios) cujas pré-condições de equipamento não sejam atendidas pelo local atual.
  - [x] **Fallback de Localização:** Se não houver GPS ou o local for desconhecido, carregar UI para "Seleção Manual de Academia" ou assumir "Sem Equipamentos" (apenas peso corporal/calistenia).