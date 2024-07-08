//
//  ViewController.swift
//  ImageFeed
//
//  Created by Mark Balikoti on 04.07.2024.
//

import UIKit

class ImagesListViewController: UIViewController  {
    // MARK: - IB Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Public Properties
    let imagelist = ImagesListCell()
    
    // MARK: - Private Properties
    // MARK: - Initializers
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorInset = .zero
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 200
    }
    func configCell(for cell: ImagesListCell) { }
    
    
}
    // MARK: - IB Actions
    // MARK: - Public Methods
   
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
                
                guard let imageListCell = cell as? ImagesListCell else {
                    return UITableViewCell()
                }
                
                configCell(for: imageListCell)
                return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
}

    // MARK: - Private Methods
   
    
    


