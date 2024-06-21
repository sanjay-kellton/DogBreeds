//
//  DogBreedImagesViewController.swift
//  Dog Breeds
//
//  Created by Sanjay Kumar on 20/06/24.
//

import UIKit

class DogBreedImagesViewController: UICollectionViewController {
    private var viewModel: DogBreedImagesViewModel

    init(breed: String) {
           self.viewModel = DogBreedImagesViewModel(breed: breed)
           let layout = UICollectionViewFlowLayout()
           layout.itemSize = CGSize(width: 100, height: 100) // Adjust item size as needed
           super.init(collectionViewLayout: layout)
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.breed
        collectionView.register(DogImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        
        viewModel.onImagesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.fetchImages()
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
    
}
