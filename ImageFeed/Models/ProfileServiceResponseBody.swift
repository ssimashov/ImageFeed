//
//  ProfileServiceResponceBody.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 14.10.2024.
//

import Foundation

struct ProfileServiceResponseBody: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
}

enum CodingKeys: String, CodingKey {
    case username = "username"
    case firstName = "first_name"
    case lastName = "last_name"
    case bio
}
