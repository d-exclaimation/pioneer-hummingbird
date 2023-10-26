//
//  Pioneer+IDE.swift
//  PioneerHummingbird
//
//  Created by d-exclaimation on 15:47.
//

import struct Hummingbird.HBRequest
import struct Hummingbird.HBResponse
import struct Pioneer.Pioneer

extension Pioneer {
    /// Common Handler for GraphQL IDE through HTTP
    /// - Parameter req: The HTTP request being made
    /// - Returns: A response with the GraphQL IDE
    public func ideHandler(req: HBRequest) -> HBResponse {
        switch playground {
        case .playground:
            return serve(using: req, html: playgroundHtml)
        case .graphiql:
            return serve(using: req, html: graphiqlHtml)
        case .sandbox:
            return serve(using: req, html: embeddedSandboxHtml)
        case let .redirect(to: cloud):
            return HBResponse.redirect(to: cloud.url, type: .permanent)
        case .disable:
            return HBResponse(status: .notFound)
        }
    }
    
    private func serve(using req: HBRequest, html: String) -> HBResponse {
        html.response(from: req)
    }
}