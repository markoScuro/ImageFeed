//
//  UserResult.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 29.08.2024.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileResult
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

