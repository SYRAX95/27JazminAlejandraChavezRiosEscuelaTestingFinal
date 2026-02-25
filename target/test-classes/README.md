# Proyecto final de Pruebas Automatizadas con Karate de la Escuela Testing de NTT DATA
Jazmin Alejandra Chavez Rios

[Swagger Petstore](https://petstore.swagger.io)

# 1.- Módulo Store

### Happy Path

Se validan los siguientes flujos funcionales:

1. Consultar inventario (`GET /store/inventory`)
2. Crear orden (`POST /store/order`)
3. Buscar orden por ID (`GET /store/order/{id}`)
4. Eliminar orden (`DELETE /store/order/{id}`)

Las órdenes se parametrizan usando múltiples JSON:

- store-order.json
- store-order-2.json

---

## Unhappy Path

### Búsqueda de orden eliminada
- Se valida que el sistema retorne 404.
- Se verifica mensaje `"Order not found"`.

### ID fuera de rango
- IDs mayores a 10
- IDs negativos
- IDs inexistentes

### Creación de orden sin body

El endpoint acepta `{}` y responde `200 OK`. (falta de validación)

### Creación con payload incompleto
El endpoint permite crear órdenes con:
- Solo `id`
- Solo `petId`
- Solo `quantity`
- Solo `shipDate`
- `status` incluso como booleano

No existe estrictas validaciones de negocio

---

## Ejecución

### Ejecutar todos los tests Store

```bash
mvn clean test -Dtest=StoreRunner -Dkarate.options="--tags @regression" -Dkarate.env=dev
```

### Ejecutar un test
```bash
mvn clean test -Dtest=StoreRunner -Dkarate.options="--tags @TEST-01" -Dkarate.env=dev
```

---


# 2.- Módulo User

## Happy Path

Se validan los siguientes flujos funcionales:

1. Crear usuario (`POST /user`)
2. Buscar usuario por username (`GET /user/{username}`)
3. Actualizar usuario (`PUT /user/{username}`)
4. Eliminar usuario (`DELETE /user/{username}`)

Los usuarios se parametrizan utilizando múltiples archivos JSON:

* `user-1.json`
* `user-2.json`

---

## Unhappy Path

---

### Buscar usuario inexistente

* Se valida que el sistema retorne `404`
* Se verifica mensaje `"User not found"`

Esto confirma el manejo adecuado cuando el recurso no existe.

---

### Crear usuario sin body

El endpoint acepta `{}` y responde `200 OK`.

* no existe validación estricta del payload requerido para la creación de usuario.

---

### Login con credenciales inválidas

Se probaron combinaciones incorrectas de:

* username inválido
* password incorrecto

El endpoint responde `200 OK` en lugar de un posible `401 Unauthorized`.

Sin validación adecuada de credenciales inválidas según buenas prácticas REST.

---

### Eliminar usuario inexistente

* Se valida que el sistema retorne `404`
* Confirma correcto manejo de recurso inexistente.

------

## Ejecución

### Ejecutar todos los tests User

```bash
mvn clean test -Dtest=UserRunner -Dkarate.options="--tags @regression" -Dkarate.env=dev
```

### Ejecutar un test específico

```bash
mvn clean test -Dtest=UserRunner -Dkarate.options="--tags @TEST-01" -Dkarate.env=dev
```

---


# Estructura del Proyecto
```
└── 📁src
    └── 📁test
        └── 📁java
            └── 📁examples
                └── 📁store
                    ├── store.feature
                    ├── StoreRunner.java
                └── 📁user
                    ├── user.feature
                    ├── UserRunner.java
                ├── ExamplesTest.java
            └── 📁resources
                └── 📁examples
                    └── 📁data
                        └── 📁store
                        └── 📁user
            ├── karate-config.js
            └── logback-test.xml
```
Jazmin Alejandra Chavez Rios