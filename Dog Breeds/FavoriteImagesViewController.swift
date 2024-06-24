//
//  FavoriteImagesViewController.swift
//  Dog Breeds
//
//  Created by Sanjay Kumar on 20/06/24.
//

import UIKit

class FavoriteImagesViewController: UICollectionViewController {
    private var viewModel: FavoriteImagesViewModel
    private var noDataLabel: UILabel = {
            let label = UILabel()
            label.text = "No data available"
            label.textAlignment = .center
            label.textColor = .gray
            label.isHidden = true // Initially hidden
            return label
        }()
    init() {
           self.viewModel = FavoriteImagesViewModel()
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // Adjust margin values here
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        super.init(collectionViewLayout: layout)
        
        // Calculate item size based on device dimensions
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing * 2) / 3 // Adjust number of items per row as needed
        let itemHeight = itemWidth // Square items, adjust height as needed
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite pictures"
        collectionView.register(DogImageCell.self, forCellWithReuseIdentifier: "FavoriteImageCell")
        viewModel.onImagesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel.loadLikedImages()
        setupNavigationBar()
        setupNoDataLabel()
    }
    
    private func setupNavigationBar() {
        
        let filterButton = UIBarButtonItem(title: "Filter by breed", style: .plain, target: self, action: #selector(filterButtonTapped))
        
        if viewModel.likedImages.count > 0{
            navigationItem.rightBarButtonItem = filterButton
        }
       
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
        cell.isUserInteration = false
        cell.likeButton.isSelected = true
        return cell
    }
    
    func filterImages(by breed: String) {
        viewModel.filterImages(by: breed)
    }
    
    private func setupNoDataLabel() {
        view.addSubview(noDataLabel)
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateNoDataLabel() {
        if viewModel.likedImages.isEmpty {
            noDataLabel.isHidden = false
        } else {
            noDataLabel.isHidden = true
        }
    }
}
