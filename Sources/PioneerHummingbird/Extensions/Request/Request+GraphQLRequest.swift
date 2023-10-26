//
//  Request+GraphQLRequest.swift
//  PioneerHummingbird
//
//  Created by d-exclaimation on 13:56.
//

import protocol Pioneer.GraphQLRequestConvertible
import class Foundation.JSONDecoder
import struct Pioneer.HTTPGraphQLRequest
import struct Hummingbird.HBRequest

extension HBRequest: GraphQLRequestConvertible {
    public func body<T>(_ decodable: T.Type) throws -> T where T : Decodable {
        try decode(as: decodable)
    }

    public func searchParams<T>(_ decodable: T.Type, at: String) -> T? where T : Decodable {
        let params = uri.queryParameters
        guard let raw = params.get(at) else { return nil }
        guard let data = raw.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(decodable, from: data)
    }

    public var isAcceptingGraphQLResponse: Bool {
         self.headers[.accept].contains(HTTPGraphQLRequest.mediaType)
    }
}