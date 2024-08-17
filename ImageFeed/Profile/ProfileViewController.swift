//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 21.07.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let profileService = ProfileService.shared
    
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
    
    private var logoutButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(named: "logout_button")!, target: ProfileViewController.self, action: nil)
        button.tintColor = UIColor(red: 0.96, green: 0.42, blue: 0.42, alpha: 1.00)
        return button
    }()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupViews()
        setupConstraints()
    }
    
    // MARK: - IB Actions
    
    @IBAction private func didTapLogoutButton(_ sender: Any) { }
    
    // MARK: - Private Methods
    
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
