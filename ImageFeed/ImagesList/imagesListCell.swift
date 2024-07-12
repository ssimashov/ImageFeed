//
//  imagesListCell.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 11.07.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdendifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
}
