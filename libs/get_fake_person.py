from faker import Faker

faker = Faker('pt_BR')

def limpar_ponto_nome(nome):
    nome_limpo = nome.replace('.', '')
    return nome_limpo

def limpar_cpf(cpf):
    cpf_limpo = cpf.replace('.', '').replace('-', '').replace('/', '')
    return cpf_limpo

def get_fake_person():
    person = {
      "name": limpar_ponto_nome(faker.name()),
      "email": faker.email(),
      "cpf": limpar_cpf(faker.cpf()),
    }
    return person