//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 23.07.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage? {
           didSet {
               guard isViewLoaded, let image else { return }
               imageView.image = image
               imageView.frame.size = image.size
               rescaleAndCenterImageInScrollView(image: image)
           }
       }
       
       var fullImageURL: String?
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!
    
    override func viewDidLoad() {
           super.viewDidLoad()
           scrollView.delegate = self
           scrollView.minimumZoomScale = 0.1
           scrollView.maximumZoomScale = 1.25

           loadImage()
       }
       
       @IBAction func didTapBackButton(_ sender: Any) {
           dismiss(animated: true, completion: nil)
       }
       
       @IBAction func didTapShareButton(_ sender: UIButton) {
           guard let image else { return }
           let share = UIActivityViewController(
               activityItems: [image],
               applicationActivities: nil
           )
           present(share, animated: true, completion: nil)
       }
    private func loadImage() {
            guard let fullImageURLString = fullImageURL, let fullImageURL = URL(string: fullImageURLString) else { return }
            
            UIBlockingProgressHUD.show()
            
            imageView.kf.setImage(with: fullImageURL) { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                
                guard let self = self else { return }
                switch result {
                case .success(let imageResult):
                    self.imageView.image = imageResult.image
                    self.imageView.contentMode = .scaleAspectFit
                    self.imageView.frame.size = imageResult.image.size
                    print("Image size: \(imageResult.image.size)")
                    self.rescaleAndCenterImageInScrollView(image: imageResult.image)
                case .failure:
                    self.showError()
                }
            }
        }

        private func showError() {
            let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так. Попробовать ещё раз?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Не надо", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
                self?.loadImage()
            })
            present(alert, animated: true, completion: nil)
        }
        
        private func rescaleAndCenterImageInScrollView(image: UIImage) {
            let minZoomScale = scrollView.minimumZoomScale
            let maxZoomScale = scrollView.maximumZoomScale
            view.layoutIfNeeded()
            let visibleRectSize = scrollView.bounds.size
            let imageSize = image.size
            let hScale = visibleRectSize.width / imageSize.width
            let vScale = visibleRectSize.height / imageSize.height
            let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
            scrollView.setZoomScale(scale, animated: false)
            scrollView.layoutIfNeeded()
            let newContentSize = scrollView.contentSize
            let x = (newContentSize.width - visibleRectSize.width) / 2
            let y = (newContentSize.height - visibleRectSize.height) / 2
            scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
        }
    }
    extension SingleImageViewController: UIScrollViewDelegate {
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            imageView
        }
    }
