//
//  ProfileServiceError.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 28.08.2024.
//

import Foundation

enum ProfileServiceError: Error {
     case invalidRequest
     case invalidURL
     case noData
     case decodingError
     case missingProfileImageURL
 }
