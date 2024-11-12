//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 12.11.2024.
//

import Foundation
import WebKit
import UIKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        OAuth2TokenStorage.shared.token = nil
        cleanCookies()
        clearUserData()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func clearUserData() {
        ProfileService.shared.clearProfileData()
        ProfileImageService.shared.clearProfileImage()
        ImagesListService.shared.clearImagesList()
    }
}
