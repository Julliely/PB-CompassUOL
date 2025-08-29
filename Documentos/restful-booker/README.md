# Restful Booker - API Tests

Automação de testes para a API [Restful Booker](https://restful-booker.herokuapp.com/) usando Robot Framework e RequestsLibrary.

## Estrutura do projeto

```
restful-booker-robot-tests/
│
├── resources/
│ └── keywords.resource
├── tests/
│ ├── 01_auth.robot
│ ├── 02_booking_get.robot
│ ├── 03_booking_post.robot
│ ├── 04_booking_put_patch.robot
│ └── 05_booking_delete.robot
├── output.xml
├── log.html
├── report.html
└── README.md
```

## Requisitos

- Python 3.x
- Robot Framework
- RequestsLibrary

Instalação:

```bash
pip install robotframework
pip install robotframework-requests
```
## Executando os testes
Rode todos os testes:

```bash
robot ./tests/
```

## Os resultados ficarão disponíveis em:

- output.xml
- log.html
- report.html

## Funcionalidades testadas

- Autenticação (/auth)
- Listar reservas (GET /booking)
- Criar reservas (POST /booking)
- Atualizar reservas (PUT /booking/{id})
- Deletar reservas (DELETE /booking/{id})

## Referências

- [Documentação API Restful Booker](https://restful-booker.herokuapp.com/apidoc/index.html)
- [Robot Framework](https://robotframework.org/)
- [RequestsLibrary](https://marketsquare.github.io/robotframework-requests/)
