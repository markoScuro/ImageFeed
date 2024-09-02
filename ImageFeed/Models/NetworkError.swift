//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 28.08.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case badRequest
    case badSession
    case badURL
    case invalidJSON
}
