from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

# CRIAÇÃO E ESTABELECIMENTO DA CONEXÃO E DA SESSÃO
DATABASEURL = "postgresql+psycopg2://postgres:<SENHA>@localhost:5432/postgres"
engine = create_engine(DATABASEURL, echo=False)

r = engine.connect().execute(text("SELECT version();")).fetchone()
print("Conectado:\n", r[0])


SessionLocal = sessionmaker(bind=engine)
session = SessionLocal()


print(50*"=")
print("Sessão Estabelecida")
print(50*"=")
