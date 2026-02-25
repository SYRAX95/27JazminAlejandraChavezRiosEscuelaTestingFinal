@regression
Feature: Automatizar feature user de API PetStore
  Como QA Automatizador,
  Quiero validar la creación y consulta de usuarios,
  Para garantizar la integridad de los datos de usuario y prevenir regresiones funcionales en los servicios del módulo User.

  Background:
    * url baseUrlPet
#mvn clean test -Dtest=UsersRunner -Dkarate.env=cert -Dkarate.options="--tags @User-1"

  @User-1 @happypath
  Scenario: Crear lista de usuarios correctamente

    * def userList = read('classpath:examples/jsonData/userListValido.json')

    Given path '/user/createWithList'
    And request userList
    When method post
    Then status 200
    And match response.code == 200
    And match response.message == 'ok'

  @User-2 @happypath
  Scenario: Crear y consultar usuario correctamente

    * def userList = read('classpath:examples/jsonData/userListValido.json')
    * def username = userList[0].username

  # Crear usuario primero
    Given path '/user/createWithList'
    And request userList
    When method post
    Then status 200
    And match response.code == 200

  # Consultar usuario creado
    Given path '/user', username
    When method get
    Then status 200
    And match response.username == username
    And match response.email == userList[0].email
    And match response == '#object'
    And match response.id == '#number'

  @User-3 @unhappypath
  Scenario: Consultar usuario inexistente

    Given path '/user', 'usuarioNoExisteXYZ'
    When method get
    Then status 404
    And match response.message == 'User not found'

  @User-4 @unhappypath
  Scenario: Crear usuario con estructura inválida

    * def userList = read('classpath:examples/jsonData/userListInvalido.json')

    Given path '/user/createWithList'
    And request userList
    When method post
    Then status 200
    And match response.code == 200
    * print 'Backend no valida estructura de usuario'

  @User-5 @unhappypath
  Scenario Outline: Consultar usuario con username inválido

    Given path '/user', <username>
    When method get
    Then status 404

    * print 'Username inválido probado:', <username>

    Examples:
      | username        |
      | 'abc123NoUser'  |
      | '###'           |
      | 'usuario_fake'  |

  @User-6 @happypath
  Scenario: Crear y actualizar usuario correctamente

    * def userList = read('classpath:examples/jsonData/userListValido.json')
    * def user = userList[0]
    * def username = user.username

  # Crear usuario primero
    Given path '/user/createWithList'
    And request userList
    When method post
    Then status 200
    And match response.code == 200

  # Modificar datos del usuario
    * set user.firstName = 'KarlaActualizada'
    * set user.email = 'karla_actualizada@gmail.com'

  # Ejecutar PUT
    Given path '/user', username
    And request user
    When method put
    Then status 200
    And match response.code == 200

  # Validar que se actualizó correctamente
    Given path '/user', username
    When method get
    Then status 200
    And match response.firstName == 'KarlaActualizada'
    And match response.email == 'karla_actualizada@gmail.com'

  @User-7 @happypath
  Scenario: Crear y eliminar usuario correctamente

    * def userList = read('classpath:examples/jsonData/userListValido.json')
    * def user = userList[1]
    * def username = user.username

  # Crear usuario primero
    Given path '/user/createWithList'
    And request userList
    When method post
    Then status 200
    And match response.code == 200

  # Eliminar usuario
    Given path '/user', username
    When method delete
    Then status 200
    And match response.message == username

  # Verificar que ya no exista
    Given path '/user', username
    When method get
    Then status 404

  @User-8 @happypath
  Scenario: Crear usuario individual correctamente

    * def user = read('classpath:examples/jsonData/userValido.json')

    Given path '/user'
    And request user
    When method post
    Then status 200

  @User-9 @happypath
  Scenario: Login exitoso

    Given path '/user/login'
    And param username = 'usuarioQA1'
    And param password = 'Test123!'
    When method get
    Then status 200
    And match response.code == 200
    And match response.message contains 'logged in user session'

  @User-10 @happypath
  Scenario: Crear lista de usuarios correctamente

    * def userList = read('classpath:examples/jsonData/userListValido.json')

    Given path '/user/createWithArray'
    And request userList
    When method post
    Then status 200
    And match response ==
    """
    {
      code: 200,
      type: '#string',
      message: 'ok'
    }
    """
    And match header Content-Type contains 'application/json'

  @User-11 @happypath
  Scenario: Crear lista y cerrar sesión correctamente

    * def userList = read('classpath:examples/jsonData/userListValido.json')

    # Crear usuarios
    Given path '/user/createWithArray'
    And request userList
    When method post
    Then status 200
    And match response.code == 200

    # Logout
    Given path '/user/logout'
    When method get
    Then status 200
    And match response ==
    """
    {
      code: 200,
      type: '#string',
      message: 'ok'
    }
    """