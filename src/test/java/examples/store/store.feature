@regression
Feature: Automatizar feature store de API PetStore
  Como QA Automatizador,
  Quiero automatizar las operaciones del modulo Store,
  Para asegurar la integridad de las transacciones de compra y prevenir regresiones.

  Background:
    * url baseUrlPet

  @Store-1 @happypath
  Scenario: Consultar inventario de mascota exitosamente
    Given path '/store/inventory'
    When method get
    Then status 200
    # si devuelve un json y no un html, xml o un text
    And match header Content-Type contains 'application/json'
    # que el body no este vacio
    And match response != null
    # que la respuesta sea un json tipo objeto y no una lista, numero o string
    And match response == '#object'
    # que la respuesta sea numerica
    And match each response.* == '#number'

  #mvn clean test -Dtest=StoresRunner -Dkarate.env=cert -Dkarate.options="--tags @Store-1"
  #mvn clean test -Dtest=StoresRunner -Dkarate.options="--tags @Store-1"
  #classpath= src/test/java

  @Store-2 @happypath
  Scenario: Crear una orden válida exitosamente

    * def orderRequest = read('classpath:examples/jsonData/ordenValida.json')
    * print orderRequest

    Given path '/store/order'
    And request orderRequest
    When method post
    Then status 200
    And match header Content-Type contains 'application/json'

# Ausencia de validación de numeros negativos en backend
  @Store-3 @unhappypath
  Scenario: Intentar crear una orden con cantidad negativa

    * def orderRequest = read('classpath:examples/jsonData/ordenInvalidaCantidad.json')
    * print orderRequest

    Given path '/store/order'
    And request orderRequest
    When method post
    Then status 400

  @Store-4 @unhappypath
  Scenario: Intentar crear una orden con body vacío

    Given path '/store/order'
    And request {}
    When method post
    Then status 400

  @Store-5 @unhappyPath
  Scenario Outline: Consultar orden con ID inválido no numérico

    Given path 'store/order', <orderId>
    When method get
    Then status 400

    * print 'ID no válido probado:', <orderId>
    * print response

    Examples:
      | orderId  |
      | 'abc'    |
      | 'test'   |
      | '@@@'    |

  @Store-6 @happypath
  Scenario: Crear y eliminar orden correctamente

  # Crear orden valida primero
    * def orderRequest = read('classpath:examples/jsonData/ordenValida.json')
    * set orderRequest.id = Math.floor(Math.random() * 100000)

    Given path 'store/order'
    And request orderRequest
    When method post
    Then status 200
    * def createdId = response.id

  # Eliminar orden valida creada
    Given path 'store/order', createdId
    When method delete
    Then status 200
    And match response.message == '' + createdId

    * print 'Orden eliminada correctamente:', createdId

  # Verificar que ya no exista
    Given path 'store/order', createdId
    When method get
    Then status 404