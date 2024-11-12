//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 26.10.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let profileViewController = ProfileViewController()
        
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "profileActive"), selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
