//
//  DigimonListViewModel.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

import Foundation

final class DigimonListViewModel {
    private(set) var digimons: [DigimonListItem] = []
    private(set) var isLoading = false
    private(set) var isFetchingMore = false
    private(set) var errorMessage: String?
    private(set) var hasMorePages = true
    private(set) var currentFilter: DigimonSearchFilter?
    
    var onUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    private let fetchDigimonListUseCase: FetchDigimonListUseCaseProtocol
    private var currentPage = 0
    private let pageSize = 8
    
    init(fetchDigimonListUseCase: FetchDigimonListUseCaseProtocol) {
        self.fetchDigimonListUseCase = fetchDigimonListUseCase
    }
    
    func fetchDigimons(filter: DigimonSearchFilter? = nil) async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        currentFilter = filter
        currentPage = 0
        digimons = []
        hasMorePages = true
        
        do {
            let response = try await fetchDigimonListUseCase.execute(page: currentPage, pageSize: pageSize, filter: currentFilter)
            digimons.append(contentsOf: response.content)
            hasMorePages = !response.pageable.nextPage.isEmpty
            currentPage += 1
            onUpdate?()
        } catch {
            errorMessage = error.localizedDescription
            onError?(error)
        }
        
        isLoading = false
    }
    
    func fetchNextPage() async {
        guard !isLoading, !isFetchingMore, hasMorePages else { return }
        isFetchingMore = true
        do {
            let response = try await fetchDigimonListUseCase.execute(
                page: currentPage,
                pageSize: pageSize,
                filter: currentFilter
            )
            digimons.append(contentsOf: response.content)
            hasMorePages = !response.pageable.nextPage.isEmpty
            currentPage += 1
            onUpdate?()
        } catch {
            errorMessage = error.localizedDescription
            onError?(error)
        }
        isFetchingMore = false
    }
}
