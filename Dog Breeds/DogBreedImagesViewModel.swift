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
    var isLoading = false{
        didSet{
            self.onImagesUpdated?(isLoading)
        }
    }
    var onImagesUpdated: ((Bool) -> Void)?
    var onError: ((Error) -> Void)?
    
    init(breed: String, apiService: DogAPIService = DogAPIService()) {
        self.breed = breed
        self.apiService = apiService
        loadLikedImages()
    }
    
    func fetchImages() {
        isLoading = true
        apiService.fetchImages(for: breed) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let images):
                self?.images = images
            case .failure(let error):
                print("Error fetching images: \(error)")
                self?.onError?(error)
            }
        }
    }
    //Get all images with liked or unliked features and show the like and unlike icon as per favorites image
    func toggleLikeImage(_ url: String) {
        if let index = likedImages.firstIndex(where: { $0.url == url }) {
            likedImages.remove(at: index)
        } else {
            let likedImage = DogImage(url: url, breed: breed)
            likedImages.append(likedImage)
        }
        // Save liked images in user default
        LikedImagesStorage.saveDogImage(likedImages)
    }
    //Get all Liked dog images
    func loadLikedImages() {
        likedImages = LikedImagesStorage.getDogImage()
    }
}
