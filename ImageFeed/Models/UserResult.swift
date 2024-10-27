//
//  UserResult.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 27.10.2024.
//


struct UserResult: Codable {
    let profileImage: ProfileServiceResponseBody.ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}