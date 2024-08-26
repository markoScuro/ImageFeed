//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 31.07.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    // MARK: - Public Properties
    
    static let shared = OAuth2TokenStorage()
    var bearerToken: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "accessToken")
        }
        set {
            if let token = newValue {
                let isSuccess = KeychainWrapper.standard.set(token, forKey: "accessToken")
                guard isSuccess else {
                    return
                }
            } else {
                KeychainWrapper.standard.removeObject(forKey: "accessToken")
            }
        }
    }
}
