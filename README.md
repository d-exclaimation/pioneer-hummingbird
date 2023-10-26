# Pioneer + Hummingbird Integration

> **Warning**
> This integration is still in heavy developmenet and may have some bugs and breaking changes.


## Usage



## Handlers

Pioneer's [Hummingbird](https://github.com/hummingbird-project/hummingbird) also exposes the HTTP handlers for GraphQL over HTTP operations, and GraphQL IDE hosting. GraphQL over WebSocket is currently is being worked on.

The current implementation can be used with manual handling. Middleware version has not been created yet. The usage should be relatively identical to the [Vapor's equivalent](https://pioneer.dexclaimation.com/docs/web-frameworks/vapor#handlers).

### GraphQL IDE hosting

[.ideHandler](/Sources/PioneerHummingbird/Http/Pioneer+IDE.swift) will serve incoming request with the configured [GraphQL IDE](https://pioneer.dexclaimation.com/docs/features/graphql-ide).

```swift
app.router.on("graphql", method: .GET) { req in
    try server.ideHandler(req: req)
}
```


### GraphQL over HTTP operations

[.httpHandler](/Sources/PioneerHummingbird/Http/Pioneer+Http.swift) will execute a GraphQL operation and return a well-formatted response.

```swift
app.router.on("graphql", method: .POST) { req in
    try await server.httpHandler(
        req: req, 
        context: { req, patch in 
            ...
        }
    )
}
```

