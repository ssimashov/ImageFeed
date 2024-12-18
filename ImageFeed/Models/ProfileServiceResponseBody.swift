//
//  ProfileServiceResponceBody.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 14.10.2024.
//


struct ProfileServiceResponseBody: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    let profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
        case profileImage = "profile_image"
    }
    
    struct ProfileImage: Codable {
        let small: String?
        let medium: String?
        let large: String?
    }
}
