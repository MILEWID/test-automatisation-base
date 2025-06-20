@REQ_jeballes @HU999 @marvel_characters_crud @marvel_api @Agente2 @E2 
Feature: Pruebas completas de la API de Personajes de Marvel

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def basePath = 'jeballes/api/characters'

  Scenario: T-API-JEBALLES-CA01-GET todos los personajes retorna un array 200 - karate
    Given path basePath
    When method GET
    Then status 200
    And match response == '#[]'

  Scenario: T-API-JEBALLES-CA02-POST crea personaje exitoso con nombre único 201 - karate
    * def uniqueName = 'Iron Man ' + java.lang.System.currentTimeMillis()
    Given path basePath
    And request
    """
    {
      "name": "#(uniqueName)",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": ["Armor", "Flight"]
    }
    """
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    And match response.name == uniqueName
    And match response.id == "#number"
    * def ironManId = response.id

  Scenario: T-API-JEBALLES-CA03-GET personaje por ID existente 200 - karate
    * def uniqueName = 'Iron Man ' + java.lang.System.currentTimeMillis()
    Given path basePath
    And request
    """
    {
      "name": "#(uniqueName)",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": ["Armor", "Flight"]
    }
    """
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    * def ironManId = response.id
    Given path basePath, ironManId
    When method GET
    Then status 200
    And match response.id == ironManId
    And match response.name == uniqueName

  Scenario: T-API-JEBALLES-CA04-GET personaje por ID inexistente 404 - karate
    Given path basePath, 9999999
    When method GET
    Then status 404
    And match response ==
    """
    { "error": "Character not found" }
    """

  Scenario: T-API-JEBALLES-CA05-POST crear personaje con nombre duplicado 400 - karate
    * def uniqueName = 'Duplicate ' + java.lang.System.currentTimeMillis()
    Given path basePath
    And request
    """
    {
      "name": "#(uniqueName)",
      "alterego": "Alguien",
      "description": "Descripción",
      "powers": ["Poder"]
    }
    """
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    Given path basePath
    And request
    """
    {
      "name": "#(uniqueName)",
      "alterego": "Otro",
      "description": "Otro",
      "powers": ["Otro"]
    }
    """
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    And match response ==
    """
    { "error": "Character name already exists" }
    """

  Scenario: T-API-JEBALLES-CA06-POST crear personaje con campos requeridos vacíos 400 - karate
    Given path basePath
    And request
    """
    {
      "name": "",
      "alterego": "",
      "description": "",
      "powers": []
    }
    """
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    And match response ==
    """
    {
      "name": "Name is required",
      "alterego": "Alterego is required",
      "description": "Description is required",
      "powers": "Powers are required"
    }
    """

  Scenario: T-API-JEBALLES-CA07-PUT actualizar personaje exitoso 200 - karate
    * def uniqueName = 'Iron Man ' + java.lang.System.currentTimeMillis()
    Given path basePath
    And request
    """
    {
      "name": "#(uniqueName)",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": ["Armor", "Flight"]
    }
    """
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    * def ironManId = response.id
    Given path basePath, ironManId
    And request
    """
    {
      "name": "#(uniqueName)",
      "alterego": "Tony Stark",
      "description": "Updated description",
      "powers": ["Armor", "Flight"]
    }
    """
    And header Content-Type = 'application/json'
    When method PUT
    Then status 200
    And match response.description == "Updated description"

  Scenario: T-API-JEBALLES-CA08-PUT actualizar personaje inexistente 404 - karate
    Given path basePath, 9999999
    And request
    """
    {
      "name": "No existe",
      "alterego": "Nadie",
      "description": "Nada",
      "powers": ["Nada"]
    }
    """
    And header Content-Type = 'application/json'
    When method PUT
    Then status 404
    And match response ==
    """
    { "error": "Character not found" }
    """

  Scenario: T-API-JEBALLES-CA09-DELETE personaje exitoso 204 - karate
    * def uniqueName = 'Iron Man ' + java.lang.System.currentTimeMillis()
    Given path basePath
    And request
    """
    {
      "name": "#(uniqueName)",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": ["Armor", "Flight"]
    }
    """
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    * def ironManId = response.id
    Given path basePath, ironManId
    When method DELETE
    Then status 204
    And match response == ""

  Scenario: T-API-JEBALLES-CA10-DELETE personaje inexistente 404 - karate
    Given path basePath, 9999999
    When method DELETE
    Then status 404
    And match response ==
    """
    { "error": "Character not found" }
    """

  # Escenarios adicionales (suits extra que pasan)


  Scenario: T-API-JEBALLES-CA11-POST crear personaje omitiendo campo powers 400 - karate
    * def faltanPoderesName = 'FaltanPoderes ' + java.lang.System.currentTimeMillis()
    Given path basePath
    And request
    """
    {
      "name": "#(faltanPoderesName)",
      "alterego": "Sin Poder",
      "description": "Faltan poderes"
    }
    """
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    And match response.powers == "Powers are required"

  Scenario: T-API-JEBALLES-CA12-GET todos los personajes retorna un array aunque esté vacío - karate
    Given path basePath
    When method GET
    Then status 200
    And match response == '#[]'