//
//  imagesListCell.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 11.07.2024.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    weak var delegate: ImagesListCellDelegate?
    static let reuseIdentifier = "ImagesListCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "LikeActive") : UIImage(named: "LikeNoActive")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    @IBAction func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}
