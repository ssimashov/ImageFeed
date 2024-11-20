//
//  ProfileViewControllerSpy.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 17.11.2024.
//

import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    var updateProfileDetailsCalled: Bool = false
    
    func profileViewCreated() {
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile) {
        updateProfileDetailsCalled = true
    }
    
    func updateAvatar(with url: URL) {
        
    }
}
