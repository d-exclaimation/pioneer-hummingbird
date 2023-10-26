// The Swift Programming Language
// https://docs.swift.org/swift-book

import Hummingbird
import Pioneer

public struct PioneerHummingbird {
    private static func ok() throws {
        let app = HBApplication()
        let server = Pioneer<HBApplication, HBRequest>(
            schema: try .init(query: .init(name: "Query", fields: [:])),
            resolver: app
        )
        app.router.on("/graphql", method: .POST, options: .editResponse) { req in 
            try await server.httpHandler(
                req: req,
                context: { req, _ in req }
            )
        }
    }
}