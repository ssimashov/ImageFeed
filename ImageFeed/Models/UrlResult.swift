//
//  UrlResult.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 30.10.2024.
//
import Foundation

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
