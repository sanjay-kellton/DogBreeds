//
//  DogBreedImagesViewModel.swift
//  Dog Breeds
//
//  Created by Sanjay Kumar on 20/06/24.
//

import Foundation

class DogBreedImagesViewModel {
    private let apiService: DogAPIService
    var breed: String
    var images: [String] = []
    var likedImages: [DogImage] = []
    var onImagesUpdated: (() -> Void)?
    
    init(breed: String, apiService: DogAPIService = DogAPIService()) {
        self.breed = breed
        self.apiService = apiService
        loadLikedImages()
    }
    
    func fetchImages() {
        apiService.fetchImages(for: breed) { [weak self] result in
            switch result {
            case .success(let images):
                self?.images = images
                self?.onImagesUpdated?()
            case .failure(let error):
                print("Error fetching images: \(error)")
            }
        }
    }
    
    func toggleLikeImage(_ url: String) {
        if let index = likedImages.firstIndex(where: { $0.url == url }) {
            likedImages.remove(at: index)
        } else {
            let likedImage = DogImage(url: url, breed: breed)
            likedImages.append(likedImage)
        }
        // Save liked images
        LikedImagesStorage.save(likedImages)
    }
    
    func loadLikedImages() {
        likedImages = LikedImagesStorage.load()
    }
}
