//
//  ProfileServiceError.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 27.10.2024.
//


enum ProfileServiceError: Error {
    case invalidRequest
    case invalidURL
    case noData
    case decodingError
    case missingProfileImageURL
}