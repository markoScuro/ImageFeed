//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 25.08.2024.
//

import Foundation

struct ProfileImage: Codable {
         let small: String?
         let medium: String?
         let large: String?
     }

struct Profile: Codable {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}

extension Profile {
    init(from profileResult: ProfileResult) {
        self.username = profileResult.username
        self.name = "\(profileResult.firstName) \(profileResult.lastName)"
        self.loginName = "@\(profileResult.username)"
        self.bio = profileResult.bio
    }
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    let profileImage: ProfileImage?
    
}
