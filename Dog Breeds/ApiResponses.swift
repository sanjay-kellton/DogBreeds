//
//  ApiResponses.swift
//  Dog Breeds
//
//  Created by Sanjay Kumar on 20/06/24.
//

import Foundation

struct BreedsResponse: Codable {
    let message: [String: [String]]
}

struct ImagesResponse: Codable {
    let message: [String]
}
