//
//  Profile.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 30.08.2024.
//

import Foundation

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

