//
//  FavoriteImagesViewModel.swift
//  Dog Breeds
//
//  Created by Sanjay Kumar on 20/06/24.
//

import Foundation

class FavoriteImagesViewModel {
    var likedImages: [DogImage] = []
    var filteredImages: [DogImage] = []
    var onImagesUpdated: (() -> Void)?
    
    init() {
        loadLikedImages()
    }
    
    func loadLikedImages() {
        likedImages = LikedImagesStorage.load()
        filteredImages = likedImages
        onImagesUpdated?()
    }
    
    func filterImages(by breed: String) {
        if breed.isEmpty {
            filteredImages = likedImages
        } else {
            filteredImages = likedImages.filter { $0.breed == breed }
        }
        onImagesUpdated?()
    }
}
