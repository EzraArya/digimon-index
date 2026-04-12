//
//  DigimonDetailViewModel.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 13/04/26.
//

import Foundation

final class DigimonDetailViewModel {
    private(set) var digimon: DigimonDetail?
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    var onUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    private let fetchDigimonDetailUseCase: FetchDigimonDetailUseCaseProtocol
    private let digimonId: Int
    
    init(digimonId: Int, fetchDigimonDetailUseCase: FetchDigimonDetailUseCaseProtocol) {
        self.digimonId = digimonId
        self.fetchDigimonDetailUseCase = fetchDigimonDetailUseCase
    }
    
    func fetchDigimon() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        onUpdate?()
        
        do {
            digimon = try await fetchDigimonDetailUseCase.execute(id: digimonId)
            isLoading = false
            onUpdate?()
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            onError?(error)
        }
    }
}
