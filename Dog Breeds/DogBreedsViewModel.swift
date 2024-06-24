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
    var isLoading = false{
        didSet{
            self.onBreedsUpdated?(isLoading)
        }
    }
    
    var onBreedsUpdated: ((Bool) -> Void)?
    var onError: ((Error) -> Void)?
    
    init(apiService: DogAPIService = DogAPIService()) {
        self.apiService = apiService
    }
    
    func fetchBreeds() {
        isLoading = true
        apiService.fetchBreeds { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let breeds):
                self?.breeds = breeds
                
            case .failure(let error):
                print("Error fetching breeds: \(error)")
                self?.onError?(error)
            }
        }
    }
}
