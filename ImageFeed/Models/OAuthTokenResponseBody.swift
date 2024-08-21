//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 20.08.2024.
//

import UIKit

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}

