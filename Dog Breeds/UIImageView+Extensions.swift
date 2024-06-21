//
//  UIImageView+Extensions.swift
//  Dog Breeds
//
//  Created by Sanjay Kumar on 20/06/24.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImage(from url: String, placeholder: UIImage? = nil) {
        // Set placeholder image if available
        if let placeholder = placeholder {
            self.image = placeholder
        }
        
        // Check if the image is already cached
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            if let image = UIImage(data: data) {
                // Cache the image
                imageCache.setObject(image, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}


