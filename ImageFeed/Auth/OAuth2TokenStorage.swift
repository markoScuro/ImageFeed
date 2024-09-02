//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 31.07.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    // MARK: - SingleTon OAuth2TokenStorage
    
    static let shared = OAuth2TokenStorage()
    private init() { }
    
    // MARK: - Properties
    
    private let tokenKey = "BearerToken"
    
    var bearerToken: String? {
        get {
            KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            guard newValue != nil else { return }
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
            }
        }
    }




