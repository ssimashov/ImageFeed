//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 17.07.2024.
//

import Foundation

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let loginLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let logoutButton = UIButton()
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let tokenStorage = OAuth2TokenStorage.shared
    
    private var profile: Profile = Profile(
        username: "ekaterina_nov",
        name: "Екатерина Новикова",
        loginName: "@ekaterina_nov",
        bio: "Hello, world!"
    )
    private var profileImageServiceObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .ypBlack
        profileImageServiceObserver = NotificationCenter.default
                 .addObserver(
                     forName: ProfileImageService.didChangeNotification,
                     object: nil,
                     queue: .main
                 ) { [weak self] _ in
                     guard let self = self else { return }
                     self.updateAvatar()
                 }
        addAvatarimageView()
        addNameLabel()
        addLoginLabel()
        addDescriptionLabel()
        addLogoutButton()
        updateProfileDetails(profile: profile)
        updateAvatar()

    }
    
    private func addAvatarimageView() {
        
        avatarImageView.image = UIImage(named: "Photo")
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }
    
    private func addNameLabel() {
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
        
    }
    
    private func addLoginLabel() {
        loginLabel.text = "@ekaterina_nov"
        loginLabel.textColor = UIColor(named: "YP Grey")
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        
        loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addDescriptionLabel() {
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addLogoutButton () {
        logoutButton.setImage(UIImage(named: "logout"), for: .normal)
        logoutButton.tintColor = UIColor(named: "YP Red")
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        logoutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
    }
    private func updateAvatar() {
         guard
             let profileImageURL = ProfileImageService.shared.avatarURL,
             let url = URL(string: profileImageURL)
         else { return }
         
        avatarImageView.kf.setImage(with: url) { result in
             switch result {
             case .success(let value):
                 print("Image: \(value.image); Image URL: \(value.source.url?.absoluteString ?? "")")
             case .failure(let error):
                 print("Error: \(error)")
             }
         }
     }
    private func fetchProfileImage(username: String) {
        profileImageService.fetchProfileImageURL(username: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageURL):
                print("Profile image URL: \(imageURL)")
                self.updateAvatar()
            case .failure(let error):
                print("Failed to fetch profile image URL: \(error)")
            }
        }
    }
    
    func updateProfileDetails(profile: Profile) {
        self.profile = profile
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
}


