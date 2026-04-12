//
//  DigimonListViewController.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 13/04/26.
//

import UIKit


final class DigimonListViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: DigimonListViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>!
    
    // MARK: - UI Components
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search Digimon (e.g. Agumon)"
        bar.delegate = self
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemGroupedBackground
        cv.delegate = self
        cv.register(DigimonCollectionViewCell.self, forCellWithReuseIdentifier: "DigimonCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Init
    init(viewModel: DigimonListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Digipedia"
        view.backgroundColor = .systemBackground
        
        setupUI()
        configureDataSource()
        bindViewModel()
        
        Task { await viewModel.fetchDigimons() }
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Diffable DataSource Setup
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { [weak self]
            (collectionView: UICollectionView, indexPath: IndexPath, digimonId: Int) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DigimonCell", for: indexPath) as? DigimonCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if let digimon = self?.viewModel.digimons.first(where: { $0.id == digimonId }) {
                cell.configure(with: digimon)
            }
            return cell
        }
    }
    
    // MARK: - The Binding
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async { // Always ensure UI updates are on main thread!
                guard let self = self else { return }
                
                // Manage spinner
                if self.viewModel.isLoading && self.viewModel.digimons.isEmpty {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
                
                var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
                snapshot.appendSections([0])
                snapshot.appendItems(self.viewModel.digimons.map { $0.id }, toSection: 0)
                
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
        }
        
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.showErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Search Bar Delegate (Filter Logic)
extension DigimonListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let query = searchBar.text?.trimmingCharacters(in: .whitespaces)
        
        // This is where you map your simple text to your DigimonSearchFilter
        let filter = (query?.isEmpty == false) ? DigimonSearchFilter(name: query) : nil
        
        Task { await viewModel.fetchDigimons(filter: filter) }
    }
}

// MARK: - UICollectionView Delegate and FlowLayout Delegate
extension DigimonListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Size items based on current collection view width to avoid deprecated UIScreen.main
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalInsets: CGFloat
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            horizontalInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        } else {
            horizontalInsets = 32 // fallback to match intended padding
        }
        let width = collectionView.bounds.width - horizontalInsets
        return CGSize(width: max(0, width), height: 100)
    }
    
    // Navigation to Detail Screen
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let digimonId = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let detailUseCase = FetchDigimonDetailUseCase(repository: DigimonRepository(networkService: NetworkService()))
        let detailVM = DigimonDetailViewModel(digimonId: digimonId, fetchDigimonDetailUseCase: detailUseCase)
        
        let detailVC = DigimonDetailViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        // If we are 150 points from the bottom, fetch next page
        if position > (contentHeight - scrollViewHeight - 150) {
            Task { await viewModel.fetchNextPage() }
        }
    }
}

