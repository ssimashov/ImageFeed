//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 17.11.2024.
//

import UIKit

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateProfileDetailsIfNeeded()
    func updateAvatar()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    init(view: ProfileViewControllerProtocol) {
        self.view = view
    }
    
    private let profileService: ProfileServiceProtocol = ProfileService.shared
    private let profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared
    private let tokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage.shared

    func viewDidLoad() {
        view?.profileViewCreated()
        updateProfileDetailsIfNeeded()
        updateAvatar()
    }

    func updateProfileDetailsIfNeeded() {
        if let profile = profileService.profile {
            view?.updateProfileDetails(profile: profile)
            fetchProfileImage(username: profile.username)
        } else {
            guard let token = tokenStorage.token else {
                print("Error: No token available")
                return
            }
            profileService.fetchProfile(token) { [weak self] result in
                switch result {
                case .success(let profile):
                    DispatchQueue.main.async {
                        self?.view?.updateProfileDetails(profile: profile)
                        self?.fetchProfileImage(username: profile.username)
                    }
                case .failure(let error):
                    print("Failed to fetch profile: \(error.localizedDescription)")
                }
            }
        }
    }

    func fetchProfileImage(username: String) {
        profileImageService.fetchProfileImageURL(username: username) { [weak self] result in
            switch result {
            case .success(let imageURL):
                print("Profile image URL: \(imageURL)")
                self?.updateAvatar()
            case .failure(let error):
                print("Failed to fetch profile image URL: \(error)")
            }
        }
    }

    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        view?.updateAvatar(with: url)
    }
}
