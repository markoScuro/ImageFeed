//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 25.08.2024.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    let profileImage: ProfileImage?
    
    struct ProfileImage: Codable {
        let small: String?
        let medium: String?
        let large: String?
    }
}
