//
//  Profile.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 27.10.2024.
//


struct Profile: Codable {
    let username: String
    let name: String
    let loginName: String
    let bio: String
}
extension Profile {
    init(from profileResult: ProfileServiceResponseBody) {
        self.username = profileResult.username
        self.name = "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")"
        self.loginName = "@\(profileResult.username)"
        self.bio = profileResult.bio ?? ""
    }
}