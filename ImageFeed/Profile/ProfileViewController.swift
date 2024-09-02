//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 21.07.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private var profile: Profile = Profile(
        username: "ekaterina_nov",
        name: "Екатерина Новикова",
        loginName: "@ekaterina_nov",
        bio: "Hello, world!"
    )
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var avatarImageView: UIImageView = {
        let image = UIImage(named: "avatar")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    private lazy var nameLabel: UILabel =  {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 23)
        return label
    }()
    
    private lazy var loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 0.68, green: 0.69, blue: 0.71, alpha: 1.00)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(named: "logout_button")!, target: ProfileViewController.self, action: nil)
        button.tintColor = UIColor(red: 0.96, green: 0.42, blue: 0.42, alpha: 1.00)
        return button
    }()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main)
        {[weak self] _ in guard let self = self else {return}
            self.updateAvatar()
        }
        
        updateAvatar()
        updateProfileDetails(profile: profile)
        setupViews()
        setupConstraints()
    }
    
    // MARK: - IB Actions
    
    @IBAction private func didTapLogoutButton(_ sender: Any) {
        //TODO
    }
    
    // MARK: - Public Methods
    
    func updateProfileDetails(profile: Profile) {
        self.profile = profile
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    // MARK: - Private Methods
    
    private func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL)
        else { return }
        
        avatarImageView.kf.setImage(with: url) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image); Image URL: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupViews() {
        [avatarImageView, nameLabel, descriptionLabel, logoutButton, loginNameLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameLabel.firstBaselineAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 26),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110),
            
            loginNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginNameLabel.heightAnchor.constraint(equalToConstant: 18),
            loginNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginNameLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 136),
            loginNameLabel.topAnchor.constraint(
                equalTo: nameLabel.lastBaselineAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 18),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 162),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -6),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
    }
}
