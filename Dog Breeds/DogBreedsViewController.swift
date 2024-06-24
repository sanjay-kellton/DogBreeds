import UIKit

class DogBreedsViewController: UICollectionViewController {
    private var viewModel = DogBreedsViewModel()
    private var activityIndicator: UIActivityIndicatorView!
    private var noDataLabel: UILabel = {
            let label = UILabel()
            label.text = "No data available"
            label.textAlignment = .center
            label.textColor = .gray
            label.isHidden = true // Initially hidden
            return label
        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dog Breeds"
        collectionView.register(DogBreedCollectionCell.self, forCellWithReuseIdentifier: "BreedCell")
        setupActivityIndicator()
        viewModel.onBreedsUpdated = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.collectionView.reloadData()
                }
            }
        }
        
        viewModel.onError = { [weak self] error in
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
        viewModel.fetchBreeds()

        setupNavigationBar()
        setupCollectionViewLayout()
        setupNoDataLabel()
    }

    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }

    private func setupNavigationBar() {
        let favoritesButton = UIBarButtonItem(title: "Favorite Pics", style: .plain, target: self, action: #selector(favoritesButtonTapped))
        navigationItem.rightBarButtonItem = favoritesButton
    }

    @objc private func favoritesButtonTapped() {
        let favoritesViewController = FavoriteImagesViewController()
        navigationController?.pushViewController(favoritesViewController, animated: true)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.breeds.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreedCell", for: indexPath) as! DogBreedCollectionCell
        cell.titleLabel.text = viewModel.breeds[indexPath.item]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let breed = viewModel.breeds[indexPath.item]
        let breedVC = DogBreedImagesViewController(breed: breed)
        navigationController?.pushViewController(breedVC, animated: true)
    }

    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let itemWidth = (collectionView.bounds.width - 3 * spacing) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 0.5)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        collectionView.collectionViewLayout = layout
    }
    
    private func setupNoDataLabel() {
        view.addSubview(noDataLabel)
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateNoDataLabel() {
        if viewModel.breeds.isEmpty {
            noDataLabel.isHidden = false
        } else {
            noDataLabel.isHidden = true
        }
    }
}
