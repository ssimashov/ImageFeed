//
//  Photo.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 28.10.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
