//
//  Pioneer+Http.swift
//  Pioneer
//
//  Created by d-exclaimation on 11:34 AM.
//

import Pioneer
import struct GraphQL.GraphQLError
import class GraphQL.GraphQLJSONEncoder
import enum GraphQL.Map
import enum GraphQL.OperationType
import struct Hummingbird.HBRequest
import struct Hummingbird.HBResponse
import struct Hummingbird.HBHTTPError
import class Foundation.JSONEncoder

public extension Pioneer {
    /// Hummingbird-based HTTP Context builder
    typealias HummingbirdHTTPContext = @Sendable (HBRequest, HBRequest.ResponsePatch) async throws -> Context

    /// Common Handler for GraphQL through HTTP
    /// - Parameter req: The HTTP request being made
    /// - Returns: A response from the GraphQL operation execution properly formatted
    func httpHandler(req: HBRequest, context: @escaping HummingbirdHTTPContext) async throws -> HBResponse {
        try await httpHandler(req: req, using: GraphQLJSONEncoder(), context: context)
    }

    /// Common Handler for GraphQL through HTTP
    /// - Parameters:
    ///   - req: The HTTP request being made
    ///   - using: The custom content encoder
    /// - Returns: A response from the GraphQL operation execution properly formatted
    func httpHandler(req: HBRequest, using encoder: GraphQLJSONEncoder, context: @escaping HummingbirdHTTPContext) async throws -> HBResponse {
        do {
            // Parsing GraphQLRequest and Context
            let httpReq = try req.httpGraphQL
            let context = try await context(req, req.response)

            // Executing into GraphQLResult
            let httpRes = await executeHTTPGraphQLRequest(for: httpReq, with: context, using: req.eventLoop)
            
            req.response.status = httpRes.status

            // Adding headers
            httpRes.headers?.forEach { (key, value) in
                req.response.headers.replaceOrAdd(name: key, value: value)
            }

            return try httpRes.result.response(from: req)
        } catch let a as HBHTTPError {
            return try a.response(using: req)
        } catch let v as GraphQLViolation {
            return try GraphQLError(message: v.message)
                .response(with: v.status(req.isAcceptingGraphQLResponse))
        } catch {
            return try error.graphql.response(using: req, with: .internalServerError)
        }
    }
}
