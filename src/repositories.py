from src.database import session
from src.models import Curso, Turma, Aluno, RegistroMatricula, Historico, pre_requisito
from sqlalchemy import select

# CRIAÇÃO DO CRUD SIMPLES


def criar_aluno(session, nome: str, email: str):
    novo_aluno = Aluno(nome=nome, email=email)
    session.add(novo_aluno)
    session.commit()
    return novo_aluno


def listar_alunos(session):
    alunos = session.query(Aluno).all()
    for aluno in alunos:
        print(aluno)


def atualizar_nome_aluno(session, nome_aluno, novo_nome):
    aluno_data = session.query(Aluno).filter_by(nome=nome_aluno).first()
    aluno_data.nome = novo_nome
    session.commit()


def excluir_curso(session, nome_curso):
    data_curso = session.query(Curso).filter_by(nome=nome_curso).first()
    session.delete(data_curso)
    session.commit()


def listar_cursos(session):
    cursos = session.query(Curso).all()
    for curso in cursos:
        print(curso)


def consultando_turmas_e_curso(session):
    tec = select(Turma).join(Turma.curso)
    turmas = session.execute(tec).scalars().all()

    for turma in turmas:
        print(
            f"Turma ID: {turma.id} | Curso: {turma.curso.nome} | Semestre: {turma.semestre}")


def consultar_cursos_e_seus_pre_requisitos(session):
    stmt = (
        select(Curso.nome, pre_requisito.c.id_prerequisito)
        .join(pre_requisito, Curso.cod_curso == pre_requisito.c.cod_curso)
    )
    resultados = session.execute(stmt).all()

    for nome_curso, id_pre in resultados:
        print(f"Curso: {nome_curso} | ID do Pré-requisito: {id_pre}")


def consultar_turmas_vagas_disponiveis(session):
    stmt = (
        select(Curso.nome, Turma.vagas)
        .join(Turma, Curso.cod_curso == Turma.cod_curso)
        .where(Turma.vagas > 15)
        .order_by(Turma.vagas.desc())
    )
    resultados = session.execute(stmt).all()
    if not resultados:
        print("Nenhuma turma encontrada com mais de 15 vagas.")

    for nome, vagas in resultados:
        print(f"Curso: {nome:<25} | Vagas Disponíveis: {vagas}")
