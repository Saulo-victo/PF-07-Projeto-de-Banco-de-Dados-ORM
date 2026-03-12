from sqlalchemy import ForeignKey, String, Integer, Table, Column, Float
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship
from src.database import engine


class Base(DeclarativeBase):
    pass


pre_requisito = Table(
    "pre_requisito",
    Base.metadata,
    Column("cod_curso",
           Integer, ForeignKey("gerenciadordealunos.curso.cod_curso")),
    Column("id_prerequisito", Integer, ForeignKey(
        "gerenciadordealunos.curso.cod_curso")), schema="gerenciadordealunos"

)


class Curso(Base):
    __tablename__ = "curso"
    __table_args__ = {"schema": "gerenciadordealunos"}

    cod_curso: Mapped[int] = mapped_column(
        Integer, primary_key=True, autoincrement=True)
    nome: Mapped[str] = mapped_column(String(50), nullable=False, unique=True)
    carga_horaria: Mapped[int] = mapped_column(Integer, nullable=False)
    ementa: Mapped[str] = mapped_column(String(300))

    pre_requisito = relationship("Curso", secondary=pre_requisito,
                                 primaryjoin=cod_curso == pre_requisito.c.cod_curso,
                                 secondaryjoin=cod_curso == pre_requisito.c.id_prerequisito,
                                 backref="dependentes")

    turma = relationship("Turma", back_populates="curso",
                         cascade="all, delete-orphan")

    def __repr__(self):
        return f"Curso: código do curso: {self.cod_curso}, nome: {self.nome}, carga_horaria: {self.carga_horaria}, ementa: {self.ementa}"


class Turma(Base):
    __tablename__ = "turma"
    __table_args__ = {"schema": "gerenciadordealunos"}

    id: Mapped[int] = mapped_column(
        Integer, primary_key=True, autoincrement=True)
    semestre: Mapped[float] = mapped_column(Float, nullable=False)
    horarios: Mapped[str] = mapped_column(String, nullable=False)
    vagas: Mapped[int] = mapped_column(Integer, nullable=False)
    local: Mapped[str] = mapped_column(String)

    cod_curso: Mapped[int] = mapped_column(
        Integer, ForeignKey("gerenciadordealunos.curso.cod_curso"))
    curso = relationship("Curso", back_populates="turma")
    registro_matricula = relationship(
        "RegistroMatricula", back_populates="turma", cascade="all, delete-orphan")


class Aluno(Base):
    __tablename__ = "aluno"
    __table_args__ = {"schema": "gerenciadordealunos"}

    num_matricula: Mapped[int] = mapped_column(
        Integer, primary_key=True, autoincrement=True)
    nome: Mapped[str] = mapped_column(String(40), unique=True, nullable=False)
    email: Mapped[str] = mapped_column(String(60), nullable=False, unique=True)
    registro_matricula = relationship(
        "RegistroMatricula", back_populates="aluno", cascade="all, delete-orphan")

    def __repr__(self):
        return f"Aluno: número da matrícula: {self.num_matricula}, nome: {self.nome}, email: {self.email}"


class RegistroMatricula(Base):
    __tablename__ = "registro_matricula"
    __table_args__ = {"schema": "gerenciadordealunos"}

    id_registro_matricula: Mapped[int] = mapped_column(
        Integer, primary_key=True, autoincrement=True)

    id_turma: Mapped[int] = mapped_column(
        Integer, ForeignKey("gerenciadordealunos.turma.id"))

    num_matricula: Mapped[int] = mapped_column(
        Integer, ForeignKey("gerenciadordealunos.aluno.num_matricula"))

    aluno = relationship(
        "Aluno", back_populates="registro_matricula")
    turma = relationship(
        "Turma", back_populates="registro_matricula")
    historico = relationship(
        "Historico", back_populates="registro_matricula", cascade="all, delete-orphan")


class Historico(Base):
    __tablename__ = "historico"
    __table_args__ = {"schema": "gerenciadordealunos"}

    id: Mapped[int] = mapped_column(
        Integer, primary_key=True, autoincrement=True)
    nota: Mapped[float] = mapped_column(Float, nullable=False)
    frequencia: Mapped[float] = mapped_column(Float, nullable=False, default=0)
    status: Mapped[str] = mapped_column(
        String, nullable=False, default="CURSANDO")

    id_registro_matricula: Mapped[int] = mapped_column(
        Integer, ForeignKey("gerenciadordealunos.registro_matricula.id_registro_matricula"))
    registro_matricula = relationship(
        "RegistroMatricula", back_populates="historico")


print(50*"=")
print("Tabelas Mapeadas")
print(50*"=")
