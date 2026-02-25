# Proyecto Final de Pruebas Automatizadas con Karate
👩‍💻 **Author:** Jazmin Alejandra Chavez Rios  
🏫 Escuela de Testing - NTT DATA

Este proyecto contiene la automatización de pruebas funcionales (Happy Path y Unhappy Path)
para los módulos **Store** y **User** de la API Swagger Petstore.

🔗 [Swagger Petstore](https://petstore.swagger.io)

## 🎯 Objetivo

Validar el correcto funcionamiento de los endpoints públicos de la API Swagger Petstore, asegurando:

- Integridad de datos
- Manejo correcto de errores
- Validación de contratos REST
- Detección de debilidades de validación en backend

## ⭐ Buenas prácticas implementadas

- Uso de archivos JSON externos para separación de datos
- Generación dinámica de IDs para evitar colisiones
- Validación de headers HTTP
- Validación de tipos de datos (#object, #number)
- Uso de Scenario Outline para pruebas parametrizadas
- Separación por módulos (Store / User)
- Uso de tags (@happypath, @unhappypath, @regression)
---
## ⚙ Requisitos

- Java 17+
- Maven 3.8+
- Conexión a internet (API pública)

---
# 1.- Módulo Store

## ✅ Happy Path

Se validan los siguientes flujos funcionales implementados en `store.feature`:

1. **Consultar inventario**  
   `GET /store/inventory`
    - Status 200
    - Content-Type `application/json`
    - Response no nulo
    - Response tipo objeto
    - Todos los valores del inventario son numéricos

2. **Crear orden válida**  
   `POST /store/order`
    - Se envía payload desde `ordenValida.json`
    - Status 200
    - Content-Type `application/json`

3. **Crear y eliminar orden correctamente**
    - Se genera ID dinámico con `Math.random()`
    - Se crea la orden (`POST /store/order`)
    - Se elimina la orden (`DELETE /store/order/{id}`)
    - Se valida eliminación correcta
    - Se verifica que al consultar nuevamente retorne `404`

---

## ❌ Unhappy Path

Se validan los siguientes escenarios negativos:

### 🔹 Crear orden con cantidad negativa
- Se envía payload desde `ordenInvalidaCantidad.json`
- Se espera `400 Bad Request`

> Nota: Se documenta ausencia de validación robusta en backend.

---

### 🔹 Crear orden con body vacío
- Se envía `{}` como request
- Se espera `400 Bad Request`

---

### 🔹 Consultar orden con ID inválido (no numérico)

Se valida mediante **Scenario Outline** con múltiples valores:

- `"abc"`
- `"test"`
- `"@@@"`

Para cada caso:
- Se espera `400 Bad Request`

---

## 📂 Archivos JSON utilizados

Los datos de prueba están centralizados en:

- `ordenValida.json`
- `ordenInvalidaCantidad.json`

Ubicación:

```
src/test/java/examples/jsonData/
```

---

## ▶ Ejecución

### Ejecutar todos los tests del módulo Store

```bash
mvn clean test -Dtest=StoresRunner -Dkarate.options="--tags @regression" -Dkarate.env=cert
```

---

### Ejecutar un escenario específico

```bash
mvn clean test -Dtest=StoresRunner -Dkarate.options="--tags @Store-1"
```


---


# 2.- Módulo User

## ✅ Happy Path

Se validan los siguientes flujos funcionales implementados en `user.feature`:

1. **Crear lista de usuarios**
   `POST /user/createWithList`
    - Se envía payload desde `userListValido.json`
    - Status 200
    - Response `code == 200`
    - Message `"ok"`

2. **Crear lista de usuarios con array**
   `POST /user/createWithArray`
    - Se envía payload desde `userListValido.json`
    - Status 200
    - Validación completa del response:
      ```json
      {
        "code": 200,
        "type": "string",
        "message": "ok"
      }
      ```
    - Validación de header `Content-Type`

3. **Crear y consultar usuario**
    - Se crea usuario con `createWithList`
    - Se consulta con `GET /user/{username}`
    - Se valida:
        - Status 200
        - Username correcto
        - Email correcto
        - Response tipo objeto
        - `id` tipo numérico

4. **Crear y actualizar usuario**
    - Se crea usuario
    - Se actualizan campos (`firstName`, `email`)
    - Se valida actualización con `GET`
    - Status 200
    - Datos actualizados correctamente

5. **Crear y eliminar usuario**
    - Se crea usuario
    - Se elimina con `DELETE /user/{username}`
    - Se valida eliminación
    - Se verifica que posteriormente retorne `404`

6. **Crear usuario individual**
   `POST /user`
    - Se envía payload desde `userValido.json`
    - Status 200

7. **Login exitoso**
   `GET /user/login`
    - Se envían parámetros `username` y `password`
    - Status 200
    - Response contiene `"logged in user session"`

---

## ❌ Unhappy Path

Se validan los siguientes escenarios negativos:

### 🔹 Consultar usuario inexistente
`GET /user/{username}`
- Se espera `404`
- Mensaje `"User not found"`

---

### 🔹 Crear usuario con estructura inválida
- Se envía payload desde `userListInvalido.json`
- El backend responde `200 OK`
- Se documenta falta de validación estructural

---

### 🔹 Consultar usuario con username inválido (Scenario Outline)

Se prueban múltiples valores:

- `"abc123NoUser"`
- `"###"`
- `"usuario_fake"`

Para cada caso:
- Se espera `404`

---

## 📂 Archivos JSON utilizados

Los datos de prueba están centralizados en:

- `userListValido.json`
- `userListInvalido.json`
- `userValido.json`

Ubicación:

```
src/test/java/examples/jsonData/
```

---

## ▶ Ejecución

### Ejecutar todos los tests del módulo User

```bash
mvn clean test -Dtest=UsersRunner -Dkarate.options="--tags @regression" -Dkarate.env=cert
```

---

### Ejecutar un escenario específico

```bash
mvn clean test -Dtest=UsersRunner -Dkarate.options="--tags @User-1"
```

---
## 🛠 Tecnologías utilizadas

- Java 17
- Maven
- Karate DSL
- JUnit 5
- Logback
- Swagger Petstore API

---

# Estructura del Proyecto proyectFinalJazmin
```
└── 📁projectFinalJazmin
    └── 📁src
        └── 📁test
            └── 📁java
                └── 📁examples
                    ├── 📁jsonData
                    │   ├── ordenInvalidaCantidad.json
                    │   ├── ordenValida.json
                    │   ├── userListInvalido.json
                    │   ├── userListValido.json
                    │   └── userValido.json
                    │
                    ├── 📁store
                    │   ├── store.feature
                    │   └── StoresRunner.java
                    │
                    ├── 📁user
                    │   ├── user.feature
                    │   └── UsersRunner.java
                    │
                    └── ExamplesTest.java
    ├── karate-config.js
    ├── logback-test.xml
    └── pom.xml
```

Jazmin Alejandra Chavez Rios
