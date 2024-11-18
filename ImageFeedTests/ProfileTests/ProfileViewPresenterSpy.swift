//
//  ProfileViewPresenterSpy.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 17.11.2024.
//


import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    
    
    var view: ImageFeed.ProfileViewControllerProtocol?
    
    var viewDidLoadCalled: Bool = false
    var updateAvatarCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func updateProfileDetailsIfNeeded() {
        
    }
    
    func didTapLogoutButton() {
        
    }
}
