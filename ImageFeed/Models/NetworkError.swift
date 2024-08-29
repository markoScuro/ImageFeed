//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 28.08.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError
    case urlSessionError
    case invalidURL
    case invalidJSON
}
