//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 17.11.2024.
//

import Foundation

protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    func viewDidLoad()
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void)
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    init(view: ImagesListViewControllerProtocol) {
        self.view = view
    }
    private let imageListService: ImagesListServiceProtocol = ImagesListService.shared
    
    
    var photos: [Photo] {
        return imageListService.photos
    }
    
    func viewDidLoad() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTableViewAnimated),
            name: ImagesListService.didChangeNotification,
            object: nil
        )
        fetchPhotosNextPage()
    }
    @objc func updateTableViewAnimated() {
        view?.updateTableViewAnimated()
    }
    
    func fetchPhotosNextPage() {
        imageListService.fetchPhotosNextPage()
    }
    
    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        imageListService.changeLike(photoId: photoId, isLike: isLike, completion)
    }
}
