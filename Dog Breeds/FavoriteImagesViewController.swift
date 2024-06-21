//
//  FavoriteImagesViewController.swift
//  Dog Breeds
//
//  Created by Sanjay Kumar on 20/06/24.
//

import UIKit

class FavoriteImagesViewController: UICollectionViewController {
    private var viewModel: FavoriteImagesViewModel
    
    init() {
           self.viewModel = FavoriteImagesViewModel()
           let layout = UICollectionViewFlowLayout()
           layout.itemSize = CGSize(width: 100, height: 100) // Adjust item size as needed
           super.init(collectionViewLayout: layout)
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite Images"
        collectionView.register(DogImageCell.self, forCellWithReuseIdentifier: "FavoriteImageCell")
        viewModel.onImagesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel.loadLikedImages()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterButtonTapped))
        navigationItem.rightBarButtonItem = filterButton
    }
    
    @objc private func filterButtonTapped() {
        let alertController = UIAlertController(title: "Select Breed", message: nil, preferredStyle: .actionSheet)
        
        let allAction = UIAlertAction(title: "All", style: .default) { [weak self] _ in
                self?.viewModel.filterImages(by: "")
            }
            alertController.addAction(allAction)
        
        let uniqueBreeds = Set(viewModel.likedImages.map { $0.breed })
        for breed in uniqueBreeds {
            let action = UIAlertAction(title: breed, style: .default) { [weak self] _ in
                self?.viewModel.filterImages(by: breed)
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteImageCell", for: indexPath) as! DogImageCell
        let dogImage = viewModel.filteredImages[indexPath.row]
        cell.imageView.loadImage(from: dogImage.url)
        cell.showLikeButton = false
        return cell
    }
    
    func filterImages(by breed: String) {
        viewModel.filterImages(by: breed)
    }
}
