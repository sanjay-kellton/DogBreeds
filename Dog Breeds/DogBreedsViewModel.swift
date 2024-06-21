//
//  DogBreedsViewModel.swift
//  Dog Breeds
//
//  Created by Sanjay Kumar on 20/06/24.
//

import Foundation

class DogBreedsViewModel {
    private let apiService: DogAPIService
    var breeds: [String] = []
    var onBreedsUpdated: (() -> Void)?
    
    init(apiService: DogAPIService = DogAPIService()) {
        self.apiService = apiService
    }
    
    func fetchBreeds() {
        apiService.fetchBreeds { [weak self] result in
            switch result {
            case .success(let breeds):
                self?.breeds = breeds
                self?.onBreedsUpdated?()
            case .failure(let error):
                print("Error fetching breeds: \(error)")
            }
        }
    }
}
