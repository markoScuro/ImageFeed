//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 19.08.2024.
//

import Foundation

struct UserResult: Codable {
    
    //        let profileImage: ProfileResult.ProfileImage
    //
    //             enum CodingKeys: String, CodingKey {
    //                 case profileImage = "profile_image"
    //             }
    //         }
    //
}


final class ProfileImageService {
    
   // MARK: - Singleton ProfileImageService
    
    static let shared = ProfileImageService()
    private init(){}
    
    // MARK: - Public Properties
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    
    // MARK: - Private Properties
    
    private (set) var avatarURL: String?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastUsername: String?
    
    // MARK: - Public Methods
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastUsername != username else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastUsername = username
        
        guard let request = makeProfileImageRequest(username: username) else {
            completion(.failure(ProfileServiceError.invalidURL))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let userProfileResult):
                    guard let profileImageURL = userProfileResult.profileImage?.large else {
                        completion(.failure(ProfileServiceError.missingProfileImageURL))
                        return
                    }
                    self?.avatarURL = profileImageURL
                    completion(.success(profileImageURL))
                    
                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImageURL]
                    )
                    
                case .failure(let error):
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .httpStatusCode(let statusCode):
                            print("HTTP status code error: \(statusCode)")
                        case .urlRequestError:
                            print("URL request error: \(error)")
                        case .urlSessionError:
                            print("URL session error: \(error)")
                        case .invalidURL:
                            print("Invalid URL error: \(error)")
                        case .invalidJSON:
                            print("Invalid JSON error: \(error)")
                        }
                    } else {
                        print("Network error: \(error)")
                    }
                    completion(.failure(error))
                }
                self?.task = nil
                self?.lastUsername = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func makeProfileImageRequest(username: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://api.unsplash.com") else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        guard let url = URL(string: "/users/\(username)", relativeTo: baseURL) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(OAuth2TokenStorage.shared.bearerToken ?? "")", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
}



