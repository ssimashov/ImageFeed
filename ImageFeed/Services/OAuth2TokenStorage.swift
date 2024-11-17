//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 20.08.2024.
//

import Foundation
import SwiftKeychainWrapper

protocol OAuth2TokenStorageProtocol {
    var token: String? { get set }
}

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    static let shared = OAuth2TokenStorage()
    private init() { }
    
    private let tokenKey = "BearerToken"
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                let isSuccess = KeychainWrapper.standard.set(token, forKey: tokenKey)
                guard isSuccess else {
                    return
                }
            } else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
            }
        }
    }
}
