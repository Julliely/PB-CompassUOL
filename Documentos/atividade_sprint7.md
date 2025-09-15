# Mapeamento de Elementos HTML — Amazon Brasil

## 1. Site Escolhido
- **Nome:** Amazon Brasil  
- **URL:** [https://www.amazon.com.br](https://www.amazon.com.br)  
- **Objetivo:** Mapear elementos HTML relevantes para automação de testes ou análise de interface, utilizando estratégias distintas para cada abordagem.

---

## 2. Estratégia 1 — Elementos
**Objetivo:** Identificar os elementos principais que serão testados ou manipulados.

| Elemento | Descrição / Função | Ações Possíveis |
|----------|-----------------|----------------|
| Barra de pesquisa | Campo onde o usuário digita o produto | Verificar presença, preencher texto, submeter busca |
| Botão “Buscar” | Botão ao lado da barra de pesquisa | Verificar visível, clicar, acionar busca |
| Lista de produtos | Cards de produtos exibidos na página de resultados | Verificar número de produtos, texto, preço, imagens |
| Botão “Adicionar ao Carrinho” | Botão de cada produto | Clicar, validar inclusão no carrinho |
| Menu de categorias | Lista de categorias no topo da página | Verificar links, navegação correta |

---

## 3. Estratégia 2 — Seletores (CSS)
**Objetivo:** Localizar elementos usando IDs, classes ou atributos estáveis.

| Elemento | Seletor CSS | Observações |
|----------|-------------|-------------|
| Barra de pesquisa | `#twotabsearchtextbox` | ID único, estável |
| Botão “Buscar” | `#nav-search-submit-button` | ID único, estável |
| Primeiro produto da lista | `.s-main-slot .s-result-item[data-component-type="s-search-result"]` | Usa atributo `data-component-type` para estabilidade |
| Botão “Adicionar ao Carrinho” do primeiro produto | `.s-main-slot .s-result-item[data-component-type="s-search-result"] .a-button-input` | CSS relativo ao card do produto |
| Menu de categorias | `#nav-hamburger-menu` | ID estável |

---

## 4. Estratégia 3 — Queries / XPath
**Objetivo:** Localizar elementos com XPath, navegando pelo DOM ou usando texto.

| Elemento | XPath | Observações |
|----------|-------|-------------|
| Barra de pesquisa | `//input[@id='twotabsearchtextbox']` | XPath simples por ID |
| Botão “Buscar” | `//input[@id='nav-search-submit-button']` | XPath direto pelo ID |
| Primeiro produto da lista | `//div[@data-component-type='s-search-result'][1]` | Seleciona o primeiro resultado da pesquisa |
| Título do primeiro produto | `//div[@data-component-type='s-search-result'][1]//h2/a/span` | XPath navegando hierarquia do card |
| Botão “Adicionar ao Carrinho” do primeiro produto | `//div[@data-component-type='s-search-result'][1]//input[@title='Adicionar ao carrinho']` | XPath baseado em atributo `title` |

---

## 5. Estratégia 4 — Hierarquia
**Objetivo:** Mapear elementos considerando a estrutura do DOM.

**Exemplo: Primeiro produto da lista de resultados**

div#search
  div.s-main-slot
    div.s-result-item[data-component-type="s-search-result"]
      div > div > h2 > a > span       → título do produto
      div > div > div > span > span > input[title="Adicionar ao carrinho"] → botão adicionar


- **Explicação:**  
  1. Começamos no container principal `div#search`.  
  2. Navegamos até a lista de resultados `div.s-main-slot`.  
  3. Selecionamos o card do produto `div.s-result-item`.  
  4. Descemos até o título ou botão dentro do card.  

- **Vantagem:** permite criar queries relativas, robustas, mesmo que IDs mudem, mantendo referência pelo contêiner principal.

---

## 6. Observações Gerais
- Combinar estratégias aumenta robustez: ex.: XPath dentro de um contêiner específico ou CSS de classes estáveis.  
- Evitar usar índices fixos para produtos se a lista puder mudar.  
- Verificar sempre se o elemento está **visível e clicável**, especialmente botões.  

