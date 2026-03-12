from src.database import session
from src.repositories import criar_aluno, listar_alunos, excluir_curso, atualizar_nome_aluno, listar_cursos, consultando_turmas_e_curso, consultar_cursos_e_seus_pre_requisitos, consultar_turmas_vagas_disponiveis


def main():
    print(50*"-")
    print("Alunos antes dos novos registros: ")
    print(50*"-")
    listar_alunos(session)

    criar_aluno(session, "Henrique Alberto Barbosa", "hab_barbosa@gmail.com")
    criar_aluno(session, "Alana Maria Albuquerque", "alana123@gmail.com")
    criar_aluno(session, "Francisco das Chagas", "chagas@gmail.com")

    print(50*"-")
    print("Alunos após os novos registros: ")
    print(50*"-")
    listar_alunos(session)

    print(50*"-")
    print("Alterando o nome Lucas Gabriel Rocha para Thiago Braga: ")
    print(50*"-")
    atualizar_nome_aluno(session, "Lucas Gabriel Rocha", "Thaigo Braga")
    listar_alunos(session)

    print(50*"-")
    print("Cursos antes da exclusão: ")
    print(50*"-")
    listar_cursos(session)

    print(50*"-")
    print("Removendo o curso Programação Orientada a Objetos")
    print(50*"-")
    excluir_curso(session, "Programação Orientada a Objetos")
    listar_cursos(session)

    print(50*"-")
    print("Consultando as turmas e quais de qual curso ela é formada, além do semestre em questão")
    print(50*"-")
    consultando_turmas_e_curso(session)

    print(50*"-")
    print("Consultando os cursos que tem pré requisitos")
    print(50*"-")
    consultar_cursos_e_seus_pre_requisitos(session)

    print(50*"-")
    print("Consultando as turmas com mais de 15 vagas e ordenando por quantidade")
    print(50*"-")
    consultar_turmas_vagas_disponiveis(session)


if __name__ == "__main__":
    main()
