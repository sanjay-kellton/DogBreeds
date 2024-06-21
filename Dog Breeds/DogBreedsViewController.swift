//
//  DogBreedsViewController.swift
//  Dog Breeds
//
//  Created by Sanjay Kumar on 20/06/24.
//

import UIKit

class DogBreedsViewController: UITableViewController {
    private var viewModel = DogBreedsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dog Breeds"
        
        viewModel.onBreedsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.fetchBreeds()
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let favoritesButton = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(favoritesButtonTapped))
        navigationItem.rightBarButtonItem = favoritesButton
    }
    
    @objc private func favoritesButtonTapped() {
        let favoritesViewController = FavoriteImagesViewController()
        navigationController?.pushViewController(favoritesViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.breeds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreedCell", for: indexPath)
        cell.textLabel?.text = viewModel.breeds[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let breed = viewModel.breeds[indexPath.row]
        let breedVC = DogBreedImagesViewController(breed: breed)
        navigationController?.pushViewController(breedVC, animated: true)
    }
}
