//
//  Photo.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 28.10.2024.
//

import Foundation

import UIKit

struct Photo {
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    init(id: String, size: CGSize, createdAt: Date? = nil, welcomeDescription: String? = nil, thumbImageURL: String, largeImageURL: String, fullImageURL: String, isLiked: Bool) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.thumbImageURL = thumbImageURL
        self.largeImageURL = largeImageURL
        self.fullImageURL = fullImageURL
        self.isLiked = isLiked
    }
    
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let fullImageURL: String
    let isLiked: Bool
    
    init(from photoResult: PhotoResult) throws {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        
        if let date = Photo.dateFormatter.date(from: photoResult.createdAt) {
            self.createdAt = date
        } else {
            throw NSError(domain: "Invalid date format", code: 0, userInfo: nil)
        }
        
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = photoResult.urls.thumb
        self.largeImageURL = photoResult.urls.regular
        self.fullImageURL = photoResult.urls.full
        self.isLiked = photoResult.likedByUser
    }
}
