//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 17.07.2024.
//


import UIKit
import Kingfisher
//import SwiftKeychainWrapper

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func profileViewCreated()
    func updateProfileDetails(profile: Profile)
    func updateAvatarImage(with url: URL)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    var presenter: ProfileViewPresenterProtocol?
    
    private lazy var exitButton = UIButton()
    private lazy var imageViewProfile = UIImageView()
    private lazy var fioLabel = UILabel()
    private lazy var userNameLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    
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
        
        let profilePresenter = ProfileViewPresenter(view: self)
        self.presenter = profilePresenter
        profilePresenter.view = self
        
        self.view.backgroundColor = UIColor.ypBlack
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
//        profileViewCreated()
//        updateProfileDetailsIfNeeded()
//        updateAvatar()
        presenter?.viewDidLoad()
    }
    
   func profileViewCreated() {
        imageViewProfile.image = UIImage(named: "defaultProfileImage")
        imageViewProfile.tintColor = .red
        imageViewProfile.layer.cornerRadius = 35
        imageViewProfile.layer.masksToBounds = true
        imageViewProfile.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageViewProfile)
        imageViewProfile.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageViewProfile.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageViewProfile.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageViewProfile.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        
        exitButton.setImage(UIImage(named: "logout"), for: .normal)
        exitButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        exitButton.tintColor = .ypRed
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        exitButton.centerYAnchor.constraint(equalTo: imageViewProfile.centerYAnchor).isActive = true
        
        fioLabel.text = ""
        fioLabel.textColor = .ypWhite
        fioLabel.font = .systemFont(ofSize: 23, weight: .bold)
        fioLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fioLabel)
        fioLabel.topAnchor.constraint(equalTo: imageViewProfile.bottomAnchor, constant: 8).isActive = true
        fioLabel.leadingAnchor.constraint(equalTo: imageViewProfile.leadingAnchor).isActive = true
        
        userNameLabel.text = ""
        userNameLabel.textColor = .ypGrey
        userNameLabel.font = .systemFont(ofSize: 13)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
        userNameLabel.topAnchor.constraint(equalTo: fioLabel.bottomAnchor, constant: 8).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: imageViewProfile.leadingAnchor).isActive = true
        
        descriptionLabel.text = ""
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: imageViewProfile.leadingAnchor).isActive = true
    }
    
    private func updateAvatar(with url: URL) {
//        guard
//            let profileImageURL = ProfileImageService.shared.avatarURL,
//            let url = URL(string: profileImageURL)
//        else { return }
        
        imageViewProfile.kf.setImage(with: url) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image); Image URL: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
//    private func updateProfileDetailsIfNeeded() {
//        if let profile = profileService.profile {
//            updateProfileDetails(profile: profile)
//            fetchProfileImage(username: profile.username)
//        } else {
//            guard let token = tokenStorage.token else {
//                print("Error: No token available")
//                return
//            }
//            profileService.fetchProfile(token) { [weak self] result in
//                switch result {
//                case .success(let profile):
//                    DispatchQueue.main.async {
//                        self?.updateProfileDetails(profile: profile)
//                        self?.fetchProfileImage(username: profile.username)
//                    }
//                case .failure(let error):
//                    print("Failed to fetch profile: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
    
//    private func fetchProfileImage(username: String) {
//        profileImageService.fetchProfileImageURL(username: username) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let imageURL):
//                print("Profile image URL: \(imageURL)")
//                self.updateAvatar()
//            case .failure(let error):
//                print("Failed to fetch profile image URL: \(error)")
//            }
//        }
//    }
    
    func updateProfileDetails(profile: Profile) {
        self.profile = profile
        fioLabel.text = profile.name
        userNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func switchToAuthViewController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
        
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {}, completion: nil)
    }
    
    @objc private func didTapButton() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        
        let logoutAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            ProfileLogoutService.shared.logout()
            self?.switchToAuthViewController()
        }
        
        let cancelAction = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
