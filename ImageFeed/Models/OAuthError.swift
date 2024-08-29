//
//  OAuthError.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 28.08.2024.
//

import Foundation

enum OAuthError: Error {
    case httpStatusCode (Int)
    case urlRequestError
}
