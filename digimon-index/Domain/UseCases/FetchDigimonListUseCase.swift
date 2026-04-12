//
//  FetchDigimonListUseCase.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

import Foundation

protocol FetchDigimonListUseCaseProtocol {
    func execute(page: Int, pageSize: Int, filter: DigimonSearchFilter?) async throws -> DigimonListResponse
}

final class FetchDigimonListUseCase: FetchDigimonListUseCaseProtocol {
    private let repository: DigimonRepositoryProtocol
    
    init(repository: DigimonRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(page: Int, pageSize: Int, filter: DigimonSearchFilter? = nil) async throws -> DigimonListResponse {
        try await repository.getDigimonList(page: page, pageSize: pageSize, filter: filter)
    }
}
