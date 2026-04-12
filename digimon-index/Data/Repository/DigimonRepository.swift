//
//  DigimonRepository.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

import Foundation

final class DigimonRepository: DigimonRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getDigimonList(page: Int, pageSize: Int, filter: DigimonSearchFilter?) async throws -> DigimonListResponse {
        try await networkService.request(endpoint: .digimonList(page: page, pageSize: pageSize, filter: filter))
    }
    
    func getDigimonDetail(id: Int) async throws -> DigimonDetail {
        try await networkService.request(endpoint: .digimonDetail(id: id))
    }
}
