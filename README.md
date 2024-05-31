# Scriptura API

A powerful yet minimalist API that serves data on biblical verses, characters, events, places, connections and teological resources. The data is served through a RESTful API or GraphQL.

## Architecture

We follow the physolophy that:

- Less is more.
- Code sometimes can be a liability more than an asset.
- A central _Souce of Truth_ of our data schema is fundamental.

So our container-based architecture is PostgreSQL centered, extended with the following technologies:

```mermaid
flowchart TD
    A(Nginx) -- RESTful API --> B(PostgREST)
    A -- GraphQL API --> C(PostGraphile)
    A -- RESTful Docs --> D(Swagger UI)
    D --> B
    B --> F(PostgreSQL)
    C --> F

```

## Usage

**Start the containers**

`docker-compose up -d`

**Tearing down the containers**

`docker-compose down --remove-orphans -v`

**Local Routing**

- `localhost:5432` - PostgreSQL
- `localhost:3000` - Restful API
- `localhost:8080` - Swagger
- `localhost:8081` - pgAdmin 4 web panel
- `localhost:5433/graphql` - GraphQL API
- `localhost:5433/graphiql` - GraphiQL Web IDE
