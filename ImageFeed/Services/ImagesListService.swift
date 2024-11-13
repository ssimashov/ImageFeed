//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 28.10.2024.
//
import Foundation

final class ImagesListService {
    static var shared = ImagesListService()
    
    private init() {}
    
    private let urlSession = URLSession.shared
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: (number: Int, total: Int)?
    private var task: URLSessionTask?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    func clearImagesList() {
        photos.removeAll()
    }
    
    func dateToString(_ date: Date?) -> String? {
        if let date = date {
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        
        let nextPage = (lastLoadedPage?.number ?? 0) + 1
        
        guard let request = makePhotosRequest(page: nextPage) else {
            return
        }
        
        task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            defer {
                self?.task = nil
            }
            
            if let error = error {
                print("Error fetching photos: \(error)")
                return
            }
            
            guard let data = data else { return }
            do {
                let photoResults = try JSONDecoder().decode([PhotoResult].self, from: data)
                let newPhotos = try photoResults.map { try Photo(from: $0) }
                DispatchQueue.main.async {
                    self?.photos += newPhotos
                    self?.lastLoadedPage = (number: nextPage, total: photoResults.count)
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                }
            } catch {
                print("Error decoding photos: \(error)")
            }
        }
        
        task?.resume()
    }
    
    private func makePhotosRequest(page: Int = 1, perPage: Int = 10, orderBy: String = "latest") -> URLRequest? {
        
        guard let url = URL(string: "/photos", relativeTo: Constants.defaultBaseURL) else {
            return nil
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "order_by", value: orderBy)
        ]
        
        guard let finalURL = components?.url else {
            return nil
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(OAuth2TokenStorage.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        let httpMethod = isLike ? "POST" : "DELETE"
        
        guard let request = makeLikeRequest(photoId: photoId, httpMethod: httpMethod) else {
            completion(.failure(NSError(domain: "Invalid request", code: 0, userInfo: nil)))
            return
        }
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            defer {
                self?.task = nil
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard let index = self.photos.firstIndex(where: { $0.id == photoId }) else {
                    completion(.failure(NSError(domain: "Photo not found", code: 0, userInfo: nil)))
                    return
                }
                
                let photo = self.photos[index]
                
                let updatedPhoto = Photo(
                    id: photo.id,
                    size: photo.size,
                    createdAt: photo.createdAt,
                    welcomeDescription: photo.welcomeDescription,
                    thumbImageURL: photo.thumbImageURL,
                    largeImageURL: photo.largeImageURL,
                    fullImageURL: photo.fullImageURL,
                    isLiked: !photo.isLiked
                )
                
                self.photos[index] = updatedPhoto
                completion(.success(()))
            }
        }
        
        task.resume()
    }
    
    private func makeLikeRequest(photoId: String, httpMethod: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://api.unsplash.com") else {
            assertionFailure("Failed to create base URL")
            return nil
        }
        
        guard let url = URL(string: "/photos/\(photoId)/like", relativeTo: baseURL) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("Bearer \(OAuth2TokenStorage.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
}
