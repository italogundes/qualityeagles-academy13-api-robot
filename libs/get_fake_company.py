from faker import Faker
import random
faker = Faker('pt_BR')

def register_company():
    random_register_company = str(random.randint(10**13, 10**14 - 1))
    return random_register_company


def get_fake_address():
    address = [
        {
            "zipCode": 99999995,
            "city": faker.city(),
            "state": faker.state_abbr(),
            "district": faker.street_prefix(),
            "street": faker.street_name(),
            "number": faker.building_number(),
            "complement": faker.neighborhood(),
            "country": faker.country()
        }
    ]
    return address

def get_fake_address_exec():
    address_exec = [
        {
            "zipCode": 99999995,
            "city": faker.city(),
            "state": faker.state_abbr(),
            "district": faker.street_prefix(),
            "street": faker.street_name(),
            "number": 11122233344,
            "complement": faker.neighborhood(),
            "country": faker.country()
        }
    ]
    return address_exec

def get_fake_address_blank_data():
    address_blank_data = [
        {
            "zipCode": "",
            "city": "",
            "state": "",
            "district": "",
            "street": "",
            "number": "",
            "complement": "",
            "country": ""
        }
    ]
    return address_blank_data

def get_fake_company():
    address = get_fake_address()
    company = {
        "corporateName": faker.company(),
        "registerCompany": register_company(),
        "mail": faker.email(),
        "matriz": faker.last_name() + " Co.",
        "responsibleContact": faker.name(),
        "telephone": 99999999999999,
        "serviceDescription": faker.text(),
        "address": address
    }
    return company
 