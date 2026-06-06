---
tags: swift, vapor
type: article
summary: Um guia passo a passo para criar sua primeira API RESTful usando Swift, mesmo sem experiência prévia
date: 2024-10-18
---

# Começando com Swift criando um CRUD com Vapor

Se você está acostumado a ver Swift apenas no contexto de desenvolvimento iOS, prepare-se para uma surpresa! Com o framework Vapor, podemos usar Swift para criar aplicações web robustas e eficientes. Neste guia amigável para iniciantes, vamos explorar como criar um CRUD (Create, Read, Update, Delete) para uma TODO List simples usando Vapor no backend e [Neon](https://neon.tech/) como nosso serviço de banco de dados PostgreSQL.

## O que é Swift e por que usá-lo para desenvolvimento web?

Swift é uma linguagem de programação moderna criada pela Apple. Embora seja mais conhecida pelo desenvolvimento iOS, seus recursos de segurança, velocidade e simplicidade também fazem dela uma excelente escolha para desenvolvimento web.

## Introdução ao Vapor

Vapor é um framework web para Swift que nos permite criar APIs e aplicações web de forma rápida e simples. Ele oferece várias ferramentas que facilitam tarefas comuns do desenvolvimento web, como rotas, autenticação e interação com banco de dados.

## O que vamos construir?

Vamos criar uma API para gerenciar uma lista de tarefas. Nossa API permitirá:

1. Criar novas tarefas
2. Listar todas as tarefas
3. Ver detalhes de uma tarefa específica
4. Atualizar uma tarefa existente
5. Excluir uma tarefa

## Pré-requisitos

Antes de começar, você precisará instalar:

1. [Swift](https://www.swift.org/install/): A linguagem de programação que vamos usar.
2. [Vapor Toolbox](https://docs.vapor.codes/): Uma ferramenta de linha de comando que facilita a criação e o gerenciamento de projetos Vapor.
3. Uma conta no [Neon](https://neon.tech/): Um serviço de banco de dados PostgreSQL na nuvem.

Não se preocupe se você nunca usou essas ferramentas antes. Vamos passar por cada etapa juntos!

## Configuração do projeto

Vamos começar criando nosso projeto Vapor. Abra seu terminal e digite:

```bash
vapor new TodoListAPI
cd TodoListAPI
```

Isso cria um novo projeto Vapor chamado "TodoListAPI" e entra na pasta do projeto.

Agora, vamos configurar as dependências do projeto. Abra o arquivo `Package.swift` no seu editor de texto favorito e substitua o conteúdo por:

```swift
// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "TodoListAPI",
    platforms: [
       .macOS(.v10_15)
    ],
    dependencies: [
        // 1. Main Vapor framework
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        // 2. Vapor's ORM for database interaction
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        // 3. Driver for PostgreSQL
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Vapor", package: "vapor")
            ],
            swiftSettings: [
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .target(name: "Run", dependencies: [.target(name: "App")]),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
```

Esse arquivo define as dependências do projeto. Estamos usando Vapor, Fluent (o ORM do Vapor) e o driver PostgreSQL.

## Configuração do banco de dados

Agora, vamos configurar a conexão com o banco de dados. No arquivo `configure.swift`, dentro da pasta `./Sources/App/`, adicione o seguinte código:

```swift
import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) throws {
    // Database configuration
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .psql)

    // Additional configurations will come here...
}
```

Essa configuração usa variáveis de ambiente para definir os detalhes da conexão com o banco. Para configurar essas variáveis, crie um arquivo chamado `.env` na raiz do projeto com o seguinte conteúdo:

```.env
DATABASE_HOST="your-neon-host.tech"
DATABASE_PORT=5432
DATABASE_USERNAME="your-username"
DATABASE_PASSWORD="your-password"
DATABASE_NAME="your-database"
```

Substitua os valores acima pelos valores fornecidos pelo Neon quando você criar seu banco de dados.

## Criando o modelo de dados

Em Swift com Vapor, usamos "models" para representar nossas entidades de banco de dados. Vamos criar um modelo para nossas tarefas.

Crie um novo arquivo chamado `Todo.swift` na pasta `Sources/App/Models` e adicione o seguinte código:

```swift
import Fluent
import Vapor

final class Todo: Model, Content {
    // 1. Name of the table in the database
    static let schema = "todos"

    // 2. Unique ID of the task
    @ID(key: .id)
    var id: UUID?

    // 3. Title of the task
    @Field(key: "title")
    var title: String

    // 4. Completion status of the task
    @Field(key: "completed")
    var completed: Bool

    // 5. Empty initializer required by Fluent
    init() { }

    // 6. Custom initializer
    init(id: UUID? = nil, title: String, completed: Bool = false) {
        self.id = id
        self.title = title
        self.completed = completed
    }
}
```

Esse modelo define a estrutura das nossas tarefas no banco de dados.

## Criando a migration

Migrations são usadas para criar e atualizar a estrutura do banco de dados. Vamos criar uma migration para a tabela de tarefas.

Crie um novo arquivo chamado `CreateTodo.swift` na pasta `Sources/App/Migrations`:

```swift
import Fluent

struct CreateTodo: Migration {
    // 1. Table creation
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("todos")
            .id()
            .field("title", .string, .required)
            .field("completed", .bool, .required, .custom("DEFAULT FALSE"))
            .create()
    }

    // 2. Table removal (in case we need to revert the migration)
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("todos").delete()
    }
}
```

Agora, adicione essa migration ao arquivo `configure.swift`:

```swift
app.migrations.add(CreateTodo())
```

## Criando o controller

Controllers são responsáveis por gerenciar as operações de CRUD. Vamos criar um controller para nossas tarefas.

Crie um novo arquivo chamado `TodoController.swift` na pasta `Sources/App/Controllers`:

```swift
import Fluent
import Vapor

struct TodoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("todos")
        todos.get(use: index)
        todos.post(use: create)
        todos.group(":todoID") { todo in
            todo.get(use: show)
            todo.put(use: update)
            todo.delete(use: delete)
        }
    }

    // 1. List all tasks
    func index(req: Request) throws -> EventLoopFuture<[Todo]> {
        return Todo.query(on: req.db).all()
    }

    // 2. Create a new task
    func create(req: Request) throws -> EventLoopFuture<Todo> {
        let todo = try req.content.decode(Todo.self)
        return todo.save(on: req.db).map { todo }
    }

    // 3. Show a specific task
    func show(req: Request) throws -> EventLoopFuture<Todo> {
        guard let todoID = req.parameters.get("todoID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return Todo.find(todoID, on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    // 4. Update an existing task
    func update(req: Request) throws -> EventLoopFuture<Todo> {
        guard let todoID = req.parameters.get("todoID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        let updatedTodo = try req.content.decode(Todo.self)
        return Todo.find(todoID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { todo in
                todo.title = updatedTodo.title
                todo.completed = updatedTodo.completed
                return todo.save(on: req.db).map { todo }
            }
    }

    // 5. Delete a task
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let todoID = req.parameters.get("todoID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return Todo.find(todoID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .noContent)
    }
}
```

## Configurando as rotas

Por fim, vamos configurar nossas rotas. No arquivo `Sources/App/routes.swift`, adicione:

```swift
import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: TodoController())
}
```

## Executando e testando

Agora estamos prontos para executar nossa aplicação! No terminal, rode:

```bash
vapor run migrate
vapor run
```

O primeiro comando executa nossas migrations, criando a tabela no banco de dados. O segundo inicia o servidor.

Você pode testar a API usando um cliente HTTP como Postman ou cURL:

- Criar uma tarefa (POST): `http://localhost:8080/todos`
  Corpo da requisição: `{"title": "Learn Swift", "completed": false}`
- Listar todas as tarefas (GET): `http://localhost:8080/todos`
- Buscar uma tarefa específica (GET): `http://localhost:8080/todos/{id}`
- Atualizar uma tarefa (PUT): `http://localhost:8080/todos/{id}`
  Corpo da requisição: `{"title": "Learn Swift and Vapor", "completed": true}`
- Excluir uma tarefa (DELETE): `http://localhost:8080/todos/{id}`

## Conclusão

Parabéns! Você acabou de criar sua primeira API RESTful usando Swift e Vapor. Isso é apenas o começo do que você pode fazer com essas ferramentas poderosas.

Algumas vantagens de usar Swift para desenvolvimento web incluem:

1. **Segurança de tipos**: Swift é uma linguagem fortemente tipada, o que ajuda a evitar muitos erros comuns.
2. **Performance**: Swift é conhecida por sua alta performance.
3. **Sintaxe moderna e clara**: A sintaxe do Swift foi projetada para ser fácil de ler e escrever.
4. **Ecossistema em crescimento**: Com frameworks como Vapor, o ecossistema de desenvolvimento web em Swift está em constante expansão.

Continue explorando e construindo com Swift e Vapor. Existe um mundo de possibilidades esperando por você!

