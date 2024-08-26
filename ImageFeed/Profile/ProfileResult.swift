//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 25.08.2024.
//

import Foundation

enum ProfileServiceError: Error {
     case invalidRequest
     case invalidURL
     case noData
     case decodingError
     case missingProfileImageURL
 }

struct ProfileImage: Codable {
         let small: String?
         let medium: String?
         let large: String?
     }

struct Profile: Codable {
    let username: String
    let name: String
    let loginName: String
    let description: String?
}

extension Profile {
    init(from profileResult: ProfileResult) {
        self.username = profileResult.username
        self.name = "\(profileResult.firstName) \(profileResult.lastName)"
        self.loginName = "@\(profileResult.username)"
        self.description = profileResult.description
    }
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let description: String?
    let profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case description
        case profileImage = "profile_image"
    }
}
