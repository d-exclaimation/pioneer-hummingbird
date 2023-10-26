//
//  GraphQLResult+HBResponse.swift
//  PioneerHummingbird
//
//  Created by d-exclaimation on 14:15.
//

import struct GraphQL.GraphQLResult
import protocol Hummingbird.HBResponseEncodable

extension GraphQLResult: HBResponseEncodable {}