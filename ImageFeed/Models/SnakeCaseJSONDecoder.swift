//
//  JSON DECODER.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 29.08.2024.
//

import Foundation

class SnakeCaseJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
    let shared = SnakeCaseJSONDecoder()
}
