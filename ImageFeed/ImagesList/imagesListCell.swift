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
    
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    
    weak var delegate: ImagesListCellDelegate?
    static let reuseIdentifier = "ImagesListCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "LikeActive") : UIImage(named: "LikeNoActive")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath, photos name: [Photo], _ table: UITableView) {
        let imageName = name[indexPath.row]
        
        guard let urlImage = URL(string: imageName.thumbImageURL) else {
            print("[configCell] Ошибка: Некорректный URL")
            return
        }
        
        cell.likeButton.imageView?.image = UIImage(named: imageName.isLiked ? "LikeActive" : "LikeNoActive")
        cell.dateLabel.text = ImagesListService.shared.dateToString(imageName.createdAt)
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: urlImage, placeholder: UIImage(named: "Loader")) { result in
            switch result {
            case .success:
                table.reloadRows(at: [indexPath], with: .automatic)
            case .failure:
                print("[configCell] Ошибка: Не удалось загрузить изображение")
                break
            }
        }
    }
    
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}
