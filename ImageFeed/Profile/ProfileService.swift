//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 17.08.2024.
//

import Foundation

final class ProfileService {
    
    struct ProfileResult: Codable {
        let username: String
        let firstName: String
        let lastName: String
        let bio: String?
        
        enum CodingKeys: String, CodingKey {
            case username
            case firstName = "first_name"
            case lastName = "last_name"
            case bio
        }
    }
    
    struct Profile {
        let username: String
        let name: String
        let loginName: String
        let bio: String?
        
        init(from profileResult: ProfileResult) {
            self.username = profileResult.username
            self.name = "\(profileResult.firstName) \(profileResult.lastName)"
            self.loginName = "@\(profileResult.username)"
            self.bio = profileResult.bio
        }
    }
    
    static let shared = ProfileService()
    private init() { }
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        if task != nil {
            task?.cancel()
        }
        
        guard let request = makeProfileRequest(token: token) else {
            completion(.failure(NetworkError.urlRequestError))
            return
        }
        
        
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profileResult):
                let profile = Profile(from: profileResult)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                print("[fetchProfile]: NetworkError - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task?.resume()
    }
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
