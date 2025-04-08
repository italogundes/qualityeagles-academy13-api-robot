***Settings***

Library    RequestsLibrary
Library    libs/get_fake_person.py
Library    libs/get_fake_company.py


***Variables***
${baseUrl}  https://quality-eagles.qacoders.dev.br/api/
${mailAdm}  sysadmin@qacoders.com
${passwordAdm}  1234@Test
${mailUser}
${idUserCreated}
${currentToken}
${tokenBlank}
${invalidToken}    fsdfsdfsdfsdfwer234324eww
${idCompanyCreated}

***Test Cases***
TC01 - Login com sucesso ADM
   ${resposta}    Realizar Login    email=${mailAdm}    senha=${passwordAdm}
   Status Should Be    200    ${resposta}
   Should Be Equal    first=Olá Qa-Coders-SYSADMIN, autenticação autorizada com sucesso!    second=${resposta.json()['msg']}

TC02 - Login com email valido e senha incorreta
    ${resposta}    Realizar Login    email=${mailAdm}    senha=12345@Test
    Status Should Be    400    ${resposta}
    Should Be Equal    first=E-mail ou senha informados são inválidos.    second=${resposta.json()['alert']}

TC03 - Login com email invalido e senha invalida
    ${resposta}    Realizar Login    email=email_qacoders.com    senha=invalid1234
    Status Should Be    400    ${resposta}
    Should Be Equal    first=E-mail ou senha informados são inválidos.    second=${resposta.json()['alert']}

TC04 - Login com email invalido e senha válida
    ${resposta}    Realizar Login    email=email_qacoders.com     senha=${passwordAdm}
    Status Should Be    400    ${resposta}
    Should Be Equal    first=E-mail ou senha informados são inválidos.    second=${resposta.json()['alert']}

TC05 - Cadastro de Usuário com Sucesso
    ${resposta}    Create User
    Set Global Variable    ${mailUser}    ${resposta['mail']}
    Set Global Variable    ${idUserCreated}    ${resposta['_id']}
    Log To Console    message=ID do usuario criado: ${idUserCreated}
    Log To Console    message=Nome do usuario criado: ${resposta['fullName']}
    Log To Console    message=Email do usuario criado: ${mailUser}

TC06 - Login com Sucesso USER
    ${resposta}    Realizar Login    email=${mailUser}    senha=1234@Test
    #Log To Console    message=Usuário Logado: ${resposta.json()['user']['fullName']}
    Status Should Be    200    ${resposta}

TC07 - Atualizar Usuário por ID com Sucesso
    ${resposta}    Update User    id_user=${idUserCreated}
    #Log To Console    message=${resposta}
    Status Should Be    200
    Should Be Equal    Dados atualizados com sucesso!    ${resposta['msg']}
    
TC08 - Atualizar status para false com sucesso
    ${user_ID}    Create User
    ${resposta}    Put Status    id_user=${user_ID['_id']}    status=false
    Status Should Be    200    ${resposta}
    Should Be Equal    Status do usuario atualizado com sucesso para status false.    ${resposta.json()['msg']}

TC09 - Atualizar status para true com sucesso
    ${user_ID}    Create User
    ${resposta}    Put Status    id_user=${user_ID['_id']}    status=true
    Status Should Be    200    ${resposta}
    Should Be Equal    Status do usuario atualizado com sucesso para status true.    ${resposta.json()['msg']}

TC10 - Listar Usuários com Sucesso
    ${token}    Pegar Token    email=${mailAdm}    senha=${passwordAdm}
    ${resposta}    GET On Session    alias=eagles    url=/user/?token=${token}
    Status Should Be    200    ${resposta}

TC11 - Deletar Usuário com Sucesso
    ${user_ID}    Create User
    ${resposta}    Delete User    id_user=${user_ID['_id']}
    Status Should Be    200    ${resposta}
    Should Be Equal    Usuário deletado com sucesso!.    ${resposta.json()['msg']}

TC12 - Deletar Usuário sem Autorização
    ${user_ID}    Create User
    ${resposta}    Delete User Unauthorized    id_user=${user_ID['_id']}
    Status Should Be    403    ${resposta}
    Should Be Equal    No token provided.    ${resposta.json()['errors'][0]}
TC13 - Cadastro de Empresa com Sucesso
    ${resposta}    Create Company
    #Log To Console    message=ID da empresa criada: ${resposta['newCompany']['_id']}
    Status Should Be    201
    Set Global Variable    ${idCompanyCreated}    ${resposta['newCompany']['_id']}

TC14 - Listar Empresas com Sucesso
    ${token}    Pegar Token    email=${mailAdm}    senha=${passwordAdm}
    ${resposta}    GET On Session    alias=eagles    url=/company/?token=${token}
    Status Should Be    200    ${resposta}

TC15 - Atualizar Dados da Empresa com Sucesso
    ${resposta}    Update Company    id_company=${idCompanyCreated}
    Log To Console    message=Retorno Atualização da Empresa: ${resposta}
    Should Be Equal    Companhia atualizada com sucesso.    ${resposta['msg']}

TC16 - Atualizar Dados da Empresa utilizando token invalido
    ${resposta}    Update Company With Invalid Token    id_company=${idCompanyCreated}
    Log To Console    message=Resposta Token Invalido: ${resposta}
    Status Should Be    403
    Should Be Equal    Failed to authenticate token.    ${resposta['errors'][0]}
TC17 - Atualizar Endereço da Empresa com Sucesso
    ${resposta}    Update Address Company    id_company=${idCompanyCreated}
    Should Be Equal    Endereço da companhia atualizado com sucesso.    ${resposta['msg']}

TC18 - Atualizar Endereço da Empresa com número tendo mais caracrteres que o limite definido
    ${resposta}    Update Address Company Exception    id_company=${idCompanyCreated}
    Status Should Be    400

TC19 - Atualizar Endereço da Empresa com campos em branco
    ${reposta}    Update Address Blank Data  id_company=${idCompanyCreated}
    #Log To Console    message=Retorno Atualização da Empresa: ${reposta}
    Status Should Be    400

TC20 - Atualizar Status da Empresa com Token Invalido
    ${resposta}    Update Status Company With Invalid Token    id_company=${idCompanyCreated}
    Log To Console    message=Retorno Atualização de Status: ${resposta}
    Status Should Be    403
    Should Be Equal    Failed to authenticate token.    ${resposta['errors'][0]}
***Keywords***
Criar Sessao
    [Documentation]  Cria sessao inicial para usar na proxima request.
    ${headers}    Create Dictionary    accept=application/json    Content-type=application/json
    Create Session    alias=eagles    url=${baseUrl}    headers=${headers}    verify=True

Pegar Token
    [Documentation]    Request usada para pegar o token..
    [Arguments]    ${email}    ${senha}
    ${body}    Create Dictionary
    ...    mail=${email}
    ...    password=${senha}
    Criar Sessao
    ${resposta}    POST On Session    alias=eagles    url=/login    json=${body}
    #Log To Console    message=Token gerado ${resposta.json()['token']}
    RETURN    ${resposta.json()['token']}

Realizar Login
    [Documentation]    Realizar Login
    [Arguments]    ${email}    ${senha}
    ${body}    Create Dictionary
    ...    mail=${email}
    ...    password=${senha}
    Criar Sessao
    ${resposta}    POST On Session    alias=eagles    expected_status=any    url=login    json=${body}
    RETURN    ${resposta}

Create User
    [Documentation]    Keyword que cria um usuário
    ${person}    Get Fake person
    ${token}    Pegar Token    email=${mailAdm}    senha=${passwordAdm}
    ${body}    Create Dictionary
    ...    fullName=${person}[name]
    ...    mail=${person}[email]
    ...    password=${passwordAdm}
    ...    accessProfile=ADMIN
    ...    cpf=${person}[cpf]
    ...    confirmPassword=${passwordAdm}
    ${resposta}    POST On Session    alias=eagles    expected_status=any     url=user/?token=${token}    json=${body}
    RETURN    ${resposta.json()['user']}

Update User
    [Documentation]    Keword para atualizar informação de um usuário específico
    [Arguments]    ${id_user}
    ${token}    Pegar Token    email=${mailUser}    senha=1234@Test
    ${body}    Create Dictionary
    ...    fullName=Nome Alterado Teste
    ...    mail=${mailUser}
    ${resposta}    PUT On Session    alias=eagles    expected_status=any    url=user/${id_user}?token=${token}    json=${body}
    RETURN    ${resposta.json()}
Delete User
    [Documentation]    Keyword para deletar um usuário pelo ID
    [Arguments]    ${id_user}
    ${token}    Pegar Token    email=${mailUser}    senha=1234@Test
    ${resposta}    DELETE On Session    alias=eagles    url=/user/${id_user}?token=${token}
    RETURN    ${resposta}   

Delete User Unauthorized
    [Documentation]    Keyword para tentar deletar usuário sem estar autorizado
    [Arguments]    ${id_user}
    ${resposta}    DELETE On Session    alias=eagles    expected_status=403    url=/user/${id_user}?token=${tokenBlank}
    RETURN    ${resposta}  
Put Status
    [Arguments]    ${id_user}    ${status}
    ${token}    Pegar Token    email=${mailUser}    senha=1234@Test
    ${body}    Create Dictionary    status=${status}
    ${resposta}    PUT On Session    alias=eagles    url=/user/status/${id_user}?token=${token}    json=${body}
    RETURN    ${resposta}

Create Company
    [Documentation]    Keyword para realizar cadastro de Empresa
    ${company}    Get Fake Company
    #Log To Console    message=${company}
    ${token}    Pegar Token    email=${mailAdm}    senha=${passwordAdm}
    ${body}    Create Dictionary
    ...    corporateName=${company}[corporateName]
    ...    registerCompany=${company}[registerCompany]
    ...    mail=${company}[mail]
    ...    matriz=${company}[matriz]
    ...    responsibleContact=${company}[responsibleContact]
    ...    telephone=${company}[telephone]
    ...    serviceDescription=${company}[serviceDescription]
    ...    address=${company}[address]
    ${resposta}    POST On Session    alias=eagles    url=company/?token=${token}    json=${body}
    RETURN    ${resposta.json()}

Update Company
    [Documentation]    Keyword para atualizar dados da empresa pelo ID
    [Arguments]    ${id_company}
    ${company}    Get Fake Company
    ${token}    Pegar Token    email=${mailAdm}      senha=${passwordAdm}
    #Log To Console    message=Objeto capturado ${company}
    ${body}    Create Dictionary
    ...    corporateName=Company Alterada
    ...    registerCompany=${company}[registerCompany]
    ...    mail=${company}[mail]
    ...    matriz=${company}[matriz]
    ...    responsibleContact=${company}[responsibleContact]
    ...    telephone=${company}[telephone]
    ...    serviceDescription=${company}[serviceDescription]
    ${resposta}    PUT On Session    alias=eagles    expected_status=any    url=company/${id_company}?token=${token}    json=${body}
    RETURN    ${resposta.json()}

Update Company With Invalid Token
    [Documentation]    Keyword para tentar atualizar dados da empresa usando um token invalido
    [Arguments]    ${id_company}
    ${company}    Get Fake Company
    ${body}    Create Dictionary
    ...    corporateName=Company Alterada
    ...    registerCompany=${company}[registerCompany]
    ...    mail=${company}[mail]
    ...    matriz=${company}[matriz]
    ...    responsibleContact=${company}[responsibleContact]
    ...    telephone=${company}[telephone]
    ...    serviceDescription=${company}[serviceDescription]
    ${resposta}    PUT On Session    alias=eagles    expected_status=403    url=company/${id_company}?token=${invalidToken}    json=${body}
    RETURN    ${resposta.json()}
Update Address Blank Data
    [Documentation]    Keyword para tentar atualizar dados de endereço da empresa enviando campos em branco
    [Arguments]    ${id_company}
    ${address_blank_data}    Get Fake Address Blank Data
    ${token}    Pegar Token    email=${mailAdm}      senha=${passwordAdm}
    ${body}    Create Dictionary    address=${address_blank_data}
    ${resposta}    PUT On Session    alias=eagles    expected_status=400    url=company/address/${id_company}?token=${token}    json=${body}
    RETURN    ${resposta.json()}

Update Address Company
    [Documentation]    Keyword para atualizar dados de endereço da empresa pelo ID
    [Arguments]    ${id_company}
    ${address}    Get Fake Address
    ${token}    Pegar Token    email=${mailAdm}    senha=${passwordAdm}
    #Log To Console    message=Objeto capturado: ${address}
    ${body}    Create Dictionary    address=${address}
    ${resposta}    PUT On Session    alias=eagles    expected_status=any    url=/company/address/${id_company}?token=${token}    json=${body}
    #Log To Console    message=${resposta.json()}
    RETURN    ${resposta.json()}

Update Address Company Exception
    [Documentation]    Keyword para atualizar dados de endereço da empresa pelo ID com excedendo o limite definido
    [Arguments]    ${id_company}
    ${address_exec}    Get Fake Address Exec
    ${token}    Pegar Token    email=${mailAdm}    senha=${passwordAdm}
    ${body}    Create Dictionary    address=${address_exec}
    ${resposta}    PUT On Session    alias=eagles    expected_status=400    url=/company/address/${id_company}?token=${token}    json=${body}
    RETURN    ${resposta.json()}

Update Status Company With Invalid Token
    [Documentation]    KeyWord para tentar atuaçizar status da empresa utilizando token invalido
    [Arguments]    ${id_company}
    ${body}    Create Dictionary    status=false
    ${resposta}    PUT On Session    alias=eagles    expected_status=403    url=/company/status/${id_company}?token=${invalidToken}    json=${body}
    RETURN    ${resposta.json()}