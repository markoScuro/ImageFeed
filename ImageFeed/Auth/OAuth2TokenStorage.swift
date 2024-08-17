//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 31.07.2024.
//

import Foundation

final class OAuth2TokenStorage {
    
    // MARK: - Public Properties
    
    static let shared = OAuth2TokenStorage()
    var bearerToken: String? {
        get {
            return userDefaults.string(forKey: "accessToken")
        }
        
        set {
            userDefaults.setValue(newValue, forKey: "accessToken")
        }
    }
    
    // MARK: - Private Properties
    
    private let userDefaults = UserDefaults.standard
}
