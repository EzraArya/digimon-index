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
    private var activeFilter = DigimonSearchFilter(name: nil, type: nil, attribute: nil, level: nil, field: nil)
    
    // MARK: - UI Components
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search Digimon (e.g. Agumon)"
        bar.delegate = self
        bar.searchBarStyle = .minimal
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return bar
    }()
    
    private lazy var searchButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "magnifyingglass")
        config.imagePlacement = .trailing
        config.imagePadding = 6
        config.cornerStyle = .capsule
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.required, for: .horizontal)
        
        button.addAction(UIAction { [weak self] _ in
            self?.performSearch()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var searchRowStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [searchBar, searchButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var filterStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var filterScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return sv
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [searchRowStackView, filterScrollView])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.addSubview(headerStackView)
        filterScrollView.addSubview(filterStackView)
        view.addSubview(collectionView)
        
        let typeButton = createFilterButton(title: "Type", items: TypeFilter.allCases.map { $0.rawValue }) { [weak self] selected in
            self?.activeFilter.type = selected.flatMap { TypeFilter(rawValue: $0) }
        }
        let attributeButton = createFilterButton(title: "Attribute", items: AttributeFilter.allCases.map { $0.rawValue }) { [weak self] selected in
            self?.activeFilter.attribute = selected.flatMap { AttributeFilter(rawValue: $0) }
        }
        let levelButton = createFilterButton(title: "Level", items: LevelFilter.allCases.map { $0.rawValue }) { [weak self] selected in
            self?.activeFilter.level = selected.flatMap { LevelFilter(rawValue: $0) }
        }
        let fieldButton = createFilterButton(title: "Field", items: FieldFilter.allCases.map { $0.rawValue }) { [weak self] selected in
            self?.activeFilter.field = selected.flatMap { FieldFilter(rawValue: $0) }
        }
        
        filterStackView.addArrangedSubview(typeButton)
        filterStackView.addArrangedSubview(attributeButton)
        filterStackView.addArrangedSubview(levelButton)
        filterStackView.addArrangedSubview(fieldButton)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),            
            searchRowStackView.heightAnchor.constraint(equalToConstant: 44),
            searchButton.heightAnchor.constraint(equalToConstant: 36),
            filterScrollView.heightAnchor.constraint(equalToConstant: 44),
            
            filterStackView.topAnchor.constraint(equalTo: filterScrollView.topAnchor),
            filterStackView.leadingAnchor.constraint(equalTo: filterScrollView.contentLayoutGuide.leadingAnchor),
            filterStackView.trailingAnchor.constraint(equalTo: filterScrollView.contentLayoutGuide.trailingAnchor),
            filterStackView.bottomAnchor.constraint(equalTo: filterScrollView.bottomAnchor),
            filterStackView.heightAnchor.constraint(equalTo: filterScrollView.heightAnchor),
            
            collectionView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 8),
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
            DispatchQueue.main.async { 
                guard let self = self else { return }
                
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
}

// MARK: - Search Bar Delegate (Filter Logic)
extension DigimonListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
}

// MARK: - UICollectionView Delegate and FlowLayout Delegate
extension DigimonListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalInsets: CGFloat
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            horizontalInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        } else {
            horizontalInsets = 32 
        }
        let width = collectionView.bounds.width - horizontalInsets
        return CGSize(width: max(0, width), height: 100)
    }
    
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
        
        guard !viewModel.digimons.isEmpty else { return }
        
        if position > (contentHeight - scrollViewHeight - 150) {
            Task { await viewModel.fetchNextPage() }
        }
    }
}

extension DigimonListViewController {

    private func createFilterButton(title: String, items: [String], selectionHandler: @escaping (String?) -> Void) -> UIButton {
        var config = UIButton.Configuration.tinted()
        config.title = title
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
        
        let button = UIButton(configuration: config)
        
        var actions = items.map { item in
            UIAction(title: item) { _ in
                button.configuration?.title = "\(item)"
                selectionHandler(item)
            }
        }
        
        let clearAction = UIAction(title: "Clear \(title) Filter", attributes: .destructive) { _ in
            button.configuration?.title = title
            selectionHandler(nil)
        }
        actions.insert(clearAction, at: 0)
        
        button.menu = UIMenu(title: "Select \(title)", children: actions)
        button.showsMenuAsPrimaryAction = true
        return button
    }
    
    private func performSearch() {
        searchBar.resignFirstResponder()
        
        let query = searchBar.text?.trimmingCharacters(in: .whitespaces)
        activeFilter.name = (query?.isEmpty == false) ? query : nil
        
        Task { await viewModel.fetchDigimons(filter: activeFilter) }
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.resetToDefaultState()
        })
        present(alert, animated: true)
    }
    
    private func resetToDefaultState() {
        searchBar.text = ""
        activeFilter = DigimonSearchFilter() 
        
        if let buttons = filterStackView.arrangedSubviews as? [UIButton], buttons.count == 4 {
            buttons[0].configuration?.title = "Type"
            buttons[1].configuration?.title = "Attribute"
            buttons[2].configuration?.title = "Level"
            buttons[3].configuration?.title = "Field"
        }
        
        Task { await viewModel.fetchDigimons(filter: activeFilter) }
    }
}