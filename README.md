# Gestor Financeiro

Aplicativo Flutter para controle de finanças pessoais, com cadastro, listagem e remoção de lançamentos financeiros, organização por categoria e persistência local de dados.

## Objetivo

Centralizar o acompanhamento financeiro em uma interface simples, com foco em:
- Registro rápido de finanças
- Visualização por mês e por dia
- Cálculo de valores de antecipação de parcelas
- Armazenamento local sem depender de backend

## Funcionalidades

- Cadastro de finança com:
  - Descrição
  - Valor em moeda brasileira
  - Taxa (%)
  - Data de vencimento
  - Data de início e fim (opcionais)
  - Categoria (opcional, com autocomplete)
- Listagem de finanças por mês
- Visualização em formato de calendário (dias da semana)
- Totalizador mensal
- Exclusão de finanças
- Atualização da listagem com pull-to-refresh

## Regras e comportamentos importantes

- Datas validadas no formato brasileiro dd/MM/yyyy
- Conversão de valores numéricos com suporte a vírgula decimal
- Cálculos financeiros para antecipação de parcela e antecipação total quando houver taxa e período definido

## Arquitetura

O projeto segue uma organização em camadas:

- core: constantes e definições base
- helpers: formatação de data, moeda e máscaras
- domain:
  - models
  - datasources interfaces
  - repositories interfaces
- data:
  - datasources (implementação com SharedPreferences)
  - repositories
- modules/finance:
  - pages
  - controllers
  - bindings
- routes: rotas e configuração de navegação

Gerenciamento de estado e navegação com GetX.

## Tecnologias

- Flutter
- Dart
- GetX
- SharedPreferences
- Intl
- UUID
- mask_text_input_formatter

## Persistência de dados

Os dados são armazenados localmente com SharedPreferences em formato JSON:
- Finanças
- Categorias

Isso permite funcionamento offline e inicialização rápida.

## Como executar

### Pré-requisitos

- Flutter SDK instalado
- Dart SDK compatível

### Passos

1. Instale as dependências:
   flutter pub get

2. Rode o app:
   flutter run

## Estrutura de evolução (roadmap)

- Edição de finança
- Gestão completa de categorias (criar/editar/remover via interface)
- Filtros avançados por período e categoria
- Gráficos e indicadores financeiros
- Backup e sincronização em nuvem

## Licença

Projeto para fins de estudo e evolução contínua.