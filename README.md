# Sistema de Gerenciamento de Alunos - ORM com SQLAlchemy
## Tecnologias Necessárias
- Python 3
- PostgreSQL
- SQLAlchemy
- psycopg2-binary

## Como Executar
### Preparação do ambiente
1. Faça o clone do repositório
``` 
  git clone https://github.com/Saulo-victo/PF-07-Projeto-de-Banco-de-Dados-ORM.git
```
2. Crie um ambiente virtual
``` 
  python -m venv nome_do_ambiente
```
3. Ative o ambiente virtual
``` 
  ./nome_do_ambiente/Scripts/activate
```
4. Instale as dependências: SQLAlchemy e psycopg2-binary
``` 
  pip install sqlalchemy
  pip install psycopg2-binary
```
### Configuração do banco
1. Abra o Dbeaver
2. Crie uma conexão com PostgreSQL
3. Garanta que o host esteja como localhost e a porta esteja como 5432
4. Crie a senha para o usuário 'postgres' e garanta que o database seja postgres
5. Execute o script do repositório presente em (./sql/script_bd.sql)
``` 
  Projects > Scripts > Link File
```
O banco foi criado e configurado
### Configurando o ORM
1. Na pasta do repositório, abra src, database.py
2. em DATABASEURL, no campo "SENHA" troque para a senha configurada
``` 
  DATABASEURL = "postgresql+psycopg2://postgres:<SENHA>@localhost:5432/postgres"
```
## Comandos de execução
``` 
  python -m main
```
## Exemplos de uso
- Criando a engine, criando a seção e estabelecendo a conexão.

<img src="https://github.com/Saulo-victo/PF-07-Projeto-de-Banco-de-Dados-ORM/blob/main/images/img01.png" alt="Texto Alternativo">

- Mapeamento de tabelas, ou seja, cada tabela do banco configurado no dbeaver foi mapeado no ORM

<img src="https://github.com/Saulo-victo/PF-07-Projeto-de-Banco-de-Dados-ORM/blob/main/images/img02.png">

- Inserindo novos registros de alunos

<img src="https://github.com/Saulo-victo/PF-07-Projeto-de-Banco-de-Dados-ORM/blob/main/images/img03.png">

- Alterando um registro nome de um aluno

<img src="https://github.com/Saulo-victo/PF-07-Projeto-de-Banco-de-Dados-ORM/blob/main/images/img04.png">

- Excluindo um curso cadastrado

<img src="https://github.com/Saulo-victo/PF-07-Projeto-de-Banco-de-Dados-ORM/blob/main/images/img05.png">

- Consultando as turmas e qual curso é ministrado nela

<img src="https://github.com/Saulo-victo/PF-07-Projeto-de-Banco-de-Dados-ORM/blob/main/images/img06.png">

- Consultando os cursos que tem pré requisitos

<img src="https://github.com/Saulo-victo/PF-07-Projeto-de-Banco-de-Dados-ORM/blob/main/images/img07.png">

- Consultando as turmas com mais de 15 vagas e ordenando por quantidade

<img src="https://github.com/Saulo-victo/PF-07-Projeto-de-Banco-de-Dados-ORM/blob/main/images/img08.png">

  




















