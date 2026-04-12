//
//  FetchDigimonDetailUseCase.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

import Foundation

protocol FetchDigimonDetailUseCaseProtocol {
    func execute(id: Int) async throws -> DigimonDetail
}

final class FetchDigimonDetailUseCase: FetchDigimonDetailUseCaseProtocol {
    private let repository: DigimonRepositoryProtocol
    
    init(repository: DigimonRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: Int) async throws -> DigimonDetail {
        try await repository.getDigimonDetail(id: id)
    }
}
