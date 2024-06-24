//
//  DogImageCell.swift
//  Dog Breeds
//
//  Created by Sanjay Kumar on 20/06/24.
//


import UIKit

class DogImageCell: UICollectionViewCell {
    var imageView: UIImageView!
    var likeButton: UIButton!
    var likeButtonAction: (() -> Void)?
    var isUserInteration: Bool = false {
            didSet {
                likeButton.isUserInteractionEnabled = !isUserInteration
            }
        }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        
        likeButton = UIButton(type: .custom)
        likeButton.setImage(UIImage(named: "love"), for: .normal)
        likeButton.setImage(UIImage(named: "favorite"), for: .selected)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        contentView.addSubview(likeButton)
        // Set constraints for imageView
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
                   likeButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8), // Adjust top offset as needed
                   likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8), // Adjust trailing offset as needed
                   likeButton.widthAnchor.constraint(equalToConstant: 28), // Adjust width as needed
                   likeButton.heightAnchor.constraint(equalToConstant: 28) // Adjust height as needed
               ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapLikeButton() {
        likeButtonAction?()
    }
}

