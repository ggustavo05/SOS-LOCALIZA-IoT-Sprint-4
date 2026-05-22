# 🚨 SOS Localiza
 
> Sistema inteligente de mapeamento de áreas de risco com Inteligência Artificial integrada ao Oracle APEX.
 
---
 
## 📋 Índice
 
- [Sobre o Projeto](#sobre-o-projeto)
- [Demonstração](#demonstração)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Arquitetura do Sistema](#arquitetura-do-sistema)
- [Funcionalidades](#funcionalidades)
- [Modelo de IA](#modelo-de-ia)
- [API REST](#api-rest)
- [Estrutura do Repositório](#estrutura-do-repositório)
- [Como Executar](#como-executar)
- [Resultados](#resultados)
- [Equipe](#equipe)
---
 
## 📌 Sobre o Projeto
 
O **SOS Localiza** é uma solução mobile que exibe áreas de risco em um mapa interativo, utilizando Inteligência Artificial para classificar o nível de risco de cada região como **baixo**, **médio** ou **alto**.
 
O processamento e a inteligência da solução residem inteiramente no **Oracle APEX**, que expõe os dados via API REST consumida pelo aplicativo mobile em React Native. Se a API estiver indisponível, o aplicativo para de funcionar — demonstrando a dependência real do APEX para o funcionamento da solução.
 
---
 
## 🎬 Demonstração
 
- 📹 **Vídeo Pitch:** [Link do YouTube]
- 🔗 **API em produção:** https://oracleapex.com/ords/oracle_soslo/risco/areas
---
 
## 🛠️ Tecnologias Utilizadas
 
| Tecnologia | Finalidade |
|-----------|-----------|
| React Native | Aplicativo mobile |
| Oracle APEX 26 | Plataforma de backend e CRUD visual |
| Oracle Database | Banco de dados relacional |
| ORDS (Oracle REST Data Services) | Exposição da API REST |
| Python 3 | Treinamento do modelo de IA |
| Scikit-learn | Biblioteca de Machine Learning |
| Random Forest | Algoritmo de classificação de risco |
| Google Colab | Ambiente de treinamento da IA |
| OpenStreetMap | Mapa interativo no app mobile |
| PL/SQL | Lógica de negócio no banco de dados |
 
---
 
## 🏗️ Arquitetura do Sistema
 
```
┌─────────────────────────────────────────────────────┐
│                  App Mobile                         │
│              (React Native +                        │
│               OpenStreetMap)                        │
└─────────────────────┬───────────────────────────────┘
                      │ GET /risco/areas
                      ▼
┌─────────────────────────────────────────────────────┐
│              Oracle APEX + ORDS                     │
│                                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │           API REST (ORDS)                   │   │
│  │  GET    /risco/areas                        │   │
│  │  POST   /risco/areas                        │   │
│  │  PUT    /risco/areas/:id                    │   │
│  │  DELETE /risco/areas/:id                    │   │
│  └──────────────────┬──────────────────────────┘   │
│                     │                               │
│  ┌──────────────────▼──────────────────────────┐   │
│  │         View: vw_areas_risco_api            │   │
│  │  (prioriza risco_ia, fallback PL/SQL)       │   │
│  └──────────────────┬──────────────────────────┘   │
│                     │                               │
│  ┌──────────────────▼──────────────────────────┐   │
│  │        Tabela: areas_risco                  │   │
│  │  + Função PL/SQL: calcular_risco()          │   │
│  │  + Coluna: risco_ia (resultado da IA)       │   │
│  └─────────────────────────────────────────────┘   │
└─────────────────────┬───────────────────────────────┘
                      │ lê/escreve previsões
                      ▼
┌─────────────────────────────────────────────────────┐
│           Python + Random Forest                    │
│                                                     │
│  1. Lê dados do Oracle                              │
│  2. Pré-processa (taxa por 1000 hab)                │
│  3. Classifica: baixo / medio / alto                │
│  4. Salva risco_ia de volta no Oracle               │
└─────────────────────────────────────────────────────┘
```
 
---
 
## ⚙️ Funcionalidades
 
### App Mobile
- Mapa interativo com OpenStreetMap
- Visualização das áreas de risco com círculos coloridos
- Verde = baixo risco, Amarelo = médio risco, Vermelho = alto risco
- Tratamento de erro quando API está indisponível
- Dependência total do Oracle APEX para funcionamento
### Oracle APEX
- CRUD completo visual (criar, listar, editar e deletar áreas)
- Função PL/SQL `calcular_risco` com lógica de negócio real
- View com regra de priorização do resultado da IA
- API REST completa com GET, POST, PUT e DELETE
### Inteligência Artificial
- Modelo Random Forest treinado em Python
- Classificação de risco em três níveis
- Acurácia de 100% no dataset de validação
- Resultado salvo diretamente no banco Oracle
---
 
## 🤖 Modelo de IA
 
### Algoritmo
**Random Forest** — ensemble de 100 árvores de decisão com profundidade máxima de 5.
 
### Features utilizadas
 
| Feature | Descrição |
|---------|-----------|
| `ocorrencias` | Número de ocorrências registradas na área |
| `populacao` | População estimada da área |
| `taxa_ocorrencias` | Ocorrências por 1000 habitantes |
| `tipo_area_encoded` | Tipo de área codificado (URBANA / PERIFERICA) |
 
### Resultado do treinamento
 
| Métrica | Valor |
|---------|-------|
| Acurácia | 100% |
| Registros de treino | 160 |
| Registros de teste | 40 |
| Classes | baixo, medio, alto |
 
### Fluxo da IA
 
```
Dados Oracle → Pré-processamento → Random Forest → Previsão → Salvar risco_ia → API → App
```
 
### Arquivos do modelo
 
| Arquivo | Descrição |
|---------|-----------|
| `modelo_risco.pkl` | Modelo Random Forest treinado |
| `encoder_tipo.pkl` | Encoder do campo tipo_area |
| `sos_localiza_ia.ipynb` | Notebook completo com treinamento |
| `matriz_confusao.png` | Matriz de confusão do modelo |
 
---
 
## 🔌 API REST
 
**Base URL:** `https://oracleapex.com/ords/oracle_soslo/risco`
 
### Endpoints
 
#### GET /areas
Retorna todas as áreas de risco com classificação da IA.
 
**Resposta:**
```json
{
  "items": [
    {
      "latitude": -23.692233,
      "longitude": -46.501288,
      "risco_previsto": "alto"
    }
  ],
  "count": 25
}
```
 
#### POST /areas
Cria uma nova área de risco.
 
**Body (Headers):**
```json
{
  "nome": "Área Nova",
  "latitude": -23.55,
  "longitude": -46.63,
  "ocorrencias": 90,
  "populacao": 5000,
  "tipo_area": "URBANA"
}
```
 
#### PUT /areas/:id
Atualiza uma área existente pelo ID.
 
#### DELETE /areas/:id
Remove uma área pelo ID.
 
---
 
## 📁 Estrutura do Repositório
 
```
sos-localiza/
├── mobile/
│   └── (código fonte do app React Native)
├── ia/
│   ├── modelo_risco.pkl
│   ├── encoder_tipo.pkl
│   ├── matriz_confusao.png
│   └── sos_localiza_ia.ipynb
├── banco/
│   ├── 01_create_table.sql
│   ├── 02_insert_dados.sql
│   ├── 03_function_calcular_risco.sql
│   ├── 04_create_view.sql
│   └── 05_alter_table_risco_ia.sql
├── docs/
│   └── fluxo_arquitetura.png
└── README.md
```
 
---
 
## 🚀 Como Executar
 
### Pré-requisitos
- Node.js 18+
- React Native CLI
- Python 3.8+
- Conta Oracle APEX
### 1. Banco de dados Oracle
Execute os scripts na pasta `banco/` em ordem:
```sql
-- 1. Criar tabela
@01_create_table.sql
 
-- 2. Inserir dados
@02_insert_dados.sql
 
-- 3. Criar função de risco
@03_function_calcular_risco.sql
 
-- 4. Criar view
@04_create_view.sql
 
-- 5. Adicionar coluna de IA
@05_alter_table_risco_ia.sql
```
 
### 2. Modelo de IA
```bash
# Abrir o notebook no Google Colab
# ia/sos_localiza_ia.ipynb
 
# Ou instalar dependências localmente
pip install scikit-learn pandas numpy matplotlib seaborn
 
# Executar o notebook célula por célula
```
 
### 3. Aplicativo Mobile
```bash
# Instalar dependências
cd mobile
npm install
 
# Atualizar a URL da API em services/apiService.js
# API_URL = 'https://oracleapex.com/ords/oracle_soslo/risco'
 
# Rodar o app
npx react-native run-android
# ou
npx react-native run-ios
```
 
---
 
## 📊 Resultados
 
### Classificação das 25 áreas de São Paulo
 
| Nível de Risco | Quantidade | Percentual |
|---------------|-----------|-----------|
| 🔴 Alto | 19 áreas | 76% |
| 🟡 Médio | 4 áreas | 16% |
| 🟢 Baixo | 2 áreas | 8% |
 
### Performance do modelo
 
```
              precision    recall  f1-score   support
 
        alto       1.00      1.00      1.00        17
       baixo       1.00      1.00      1.00        10
       medio       1.00      1.00      1.00        13
 
    accuracy                           1.00        40
```
 
---
 
## 👨‍💻 Equipe
 
| Nome | RM |
|------|----|
| Amanda Galdino | 560066 |
| Bruno Cantacini | 560242 |
| Gustavo Gonçalves | 556823 |
 
---
 
## 📄 Licença
 
Este projeto foi desenvolvido para fins acadêmicos — FIAP 2026.
 
