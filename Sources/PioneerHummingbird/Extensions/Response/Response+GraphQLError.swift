//
//  Response+GraphQLError.swift
//  PioneerHummingbird
//
//  Created by d-exclaimation on 14:35.
//

import struct GraphQL.GraphQLError
import struct GraphQL.GraphQLResult
import struct NIOHTTP1.HTTPHeaders
import struct Hummingbird.HBRequest
import struct Hummingbird.HBResponse
import struct Hummingbird.HBHTTPError
import class Foundation.JSONEncoder
import enum Hummingbird.HBResponseBody
import enum Hummingbird.HTTPResponseStatus
import protocol Hummingbird.HBResponseEncodable
import protocol Hummingbird.HBHTTPResponseError
import NIO

extension HBHTTPError {
    func response(using req: HBRequest) throws -> HBResponse {
        try GraphQLError(message: body ?? "An error occurred").response(using: req, with: status, and: headers)
    }
}

extension HBHTTPResponseError {
    func response(using req: HBRequest) throws -> HBResponse {
        try GraphQLError(message: "\(self)").response(using: req, with: status, and: headers)
    }
}


extension GraphQLError: HBResponseEncodable {
    func response(with code: HTTPResponseStatus) throws -> HBResponse {
        let data = try JSONEncoder().encode(self)
        return HBResponse(status: code, body: .byteBuffer(.init(data: data)))
    }

    func response(using req: HBRequest, with code: HTTPResponseStatus, and headers: HTTPHeaders? = nil) throws -> HBResponse {
        headers?.forEach { name, value in 
            req.response.headers.replaceOrAdd(name: name, value: value)
        }
        req.response.status = code
        return try response(from: req)
    }
}

extension Array where Element == GraphQLError {
    func response(with code: HTTPResponseStatus) throws -> HBResponse {
        let data = try JSONEncoder().encode(GraphQLResult(data: nil, errors: self))
        return HBResponse(status: code, body: .byteBuffer(.init(data: data)))
    }

    func response(using req: HBRequest) throws -> HBResponse {
        return try response(from: req)
    }
}