//
//  LikedImagesStorage.swift
//  Dog Breeds
//
//  Created by Sanjay Kumar on 20/06/24.
//

import Foundation

struct LikedImagesStorage {
    private static let key = "likedImages"
    
    static func saveDogImage(_ images: [DogImage]) {
        let data = try? JSONEncoder().encode(images)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    static func getDogImage() -> [DogImage] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let images = try? JSONDecoder().decode([DogImage].self, from: data) else {
            return []
        }
        return images
    }
}
