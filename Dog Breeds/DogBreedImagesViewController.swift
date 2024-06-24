//
//  DogBreedImagesViewController.swift
//  Dog Breeds
//
//  Created by Sanjay Kumar on 20/06/24.
//

import UIKit

class DogBreedImagesViewController: UICollectionViewController {
    private var viewModel: DogBreedImagesViewModel
    private var activityIndicator: UIActivityIndicatorView!
    private var noDataLabel: UILabel = {
            let label = UILabel()
            label.text = "No data available"
            label.textAlignment = .center
            label.textColor = .gray
            label.isHidden = true // Initially hidden
            return label
        }()
    init(breed: String) {
           self.viewModel = DogBreedImagesViewModel(breed: breed)
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
        title = viewModel.breed
        collectionView.register(DogImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        setupActivityIndicator()
        viewModel.onImagesUpdated = { [weak self] isLoading in
            DispatchQueue.main.async {
                
                if isLoading{
                    self?.activityIndicator.startAnimating()
                }else{
                    self?.activityIndicator.stopAnimating()
                    self?.collectionView.reloadData()
                }
                
            }
        }
        viewModel.onError = { [weak self] error in
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
        viewModel.fetchImages()
        setupNoDataLabel()
    }
    
    private func setupActivityIndicator() {
           activityIndicator = UIActivityIndicatorView(style: .medium)
           activityIndicator.hidesWhenStopped = true
           activityIndicator.center = view.center
           view.addSubview(activityIndicator)
       }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! DogImageCell
        let imageUrl = viewModel.images[indexPath.row]
        let placeholderImage = UIImage(named: "placeholder")
        cell.imageView.loadImage(from: imageUrl, placeholder: placeholderImage)
        cell.likeButton.isSelected = viewModel.likedImages.contains { $0.url == imageUrl }
        cell.likeButtonAction = { [weak self] in
            self?.viewModel.toggleLikeImage(imageUrl)
            cell.likeButton.isSelected = self?.viewModel.likedImages.contains { $0.url == imageUrl } ?? false
        }
        return cell
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
