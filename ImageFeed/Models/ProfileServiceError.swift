//
//  ProfileServiceError.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 28.08.2024.
//

import Foundation

enum ProfileServiceError: Error {
    case badRequest
    case badURL
    case noData
    case decodingError
    case missingProfileImageURL
}
