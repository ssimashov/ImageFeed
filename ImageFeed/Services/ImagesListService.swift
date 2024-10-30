//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 28.10.2024.
//
import Foundation


class ImagesListService {
    static var shared = ImagesListService()
    private init() {}
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServicedidChange")
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: (number: Int, total: Int)?
    private var task: URLSessionTask?
    
    func fetchPhotosNextPage(){
        assert(Thread.isMainThread)
        guard task == nil else { return }
        
        let nextPage = (lastLoadedPage?.number ?? 0) + 1
        
        guard let request = makePhotosRequest(page: nextPage) else {
            print("Failed to create request")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
          
            switch result {
            case .success(let photos): break
                
            case .failure(let error):
                if let networkError = error as? NetworkError {
                    switch networkError {
                    case .httpStatusCode(let statusCode):
                        print("HTTP status code error: \(statusCode)")
                    case .urlRequestError(let requestError):
                        print("URL request error: \(requestError)")
                    case .urlSessionError:
                        print("URL session error: \(error)")
                    }
                } else {
                    print("Other network error: \(error)")
                }
            }
                self?.task = nil
            self?.lastLoadedPage = nextPage
            
        }
        self.task = task
        task.resume()
    }
    
    func makePhotosRequest(page: Int) -> URLRequest? {
        guard let baseURL = Constants.defaultBaseURL else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            assertionFailure("Failed to create URLComponents")
            return nil
        }
        
        components.path = "/photos"
        components.queryItems = [
            URLQueryItem(name: "page", value: String(page))
        ]
        
        guard let url = components.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(OAuth2TokenStorage.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
}


