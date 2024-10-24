//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Sergey Simashov on 19.08.2024.
//
import UIKit

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private init() {}
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            let error = FetchOAuthTokenError.invalidResponse
            print("Error creating OAuth token request: \(error)")
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let tokenResponse = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    OAuth2TokenStorage.shared.token = tokenResponse.accessToken
                    completion(.success(tokenResponse.accessToken))
                } catch {
                    print("Error decoding OAuth token response: \(error)")
                    completion(.failure(FetchOAuthTokenError.decodingError))
                }
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
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            return nil
        }
        
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
}
