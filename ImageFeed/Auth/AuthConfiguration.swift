//
//  Constants.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 11.08.2024.
//

import Foundation

enum Constants {
    static let accessKey = "W0g9M4o1k7QiIXIyg1VMozjr3mMWXe1_Q3-LbiYiHa4"
    static let secretKey = "XKx3MaUMzHWQqnDNSVwag1JomrdzDWwldvQpIx7y7x8"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        .init (accessKey: Constants.accessKey,
               secretKey: Constants.secretKey,
               redirectURI: Constants.redirectURI,
               accessScope: Constants.accessScope,
               defaultBaseURL: Constants.defaultBaseURL,
               authURLString: Constants.unsplashAuthorizeURLString
        )
    }
}
