//
//  DogAPIService.swift
//  Dog Breeds
//
//  Created by Sanjay Kumar on 20/06/24.
//

import Foundation

class DogAPIService {
    static let baseURL = "https://dog.ceo/api"
    
    func fetchBreeds(completion: @escaping (Result<[String], Error>) -> Void) {
        let url = URL(string: "\(DogAPIService.baseURL)/breeds/list/all")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "dataNilError", code: -100001, userInfo: nil)))
                return
            }
            
            do {
                let breedsResponse = try JSONDecoder().decode(BreedsResponse.self, from: data)
                let breeds = breedsResponse.message.keys.map { $0 }
                completion(.success(breeds))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchImages(for breed: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let url = URL(string: "\(DogAPIService.baseURL)/breed/\(breed)/images")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "dataNilError", code: -100001, userInfo: nil)))
                return
            }
            
            do {
                let imagesResponse = try JSONDecoder().decode(ImagesResponse.self, from: data)
                completion(.success(imagesResponse.message))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

