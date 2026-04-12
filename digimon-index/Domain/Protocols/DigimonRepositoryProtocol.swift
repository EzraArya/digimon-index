//
//  DigimonRepositoryProtocol.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

protocol DigimonRepositoryProtocol {
    func getDigimonList(page: Int, pageSize: Int, filter: DigimonSearchFilter?) async throws -> DigimonListResponse
    func getDigimonDetail(id: Int) async throws -> DigimonDetail
}

extension DigimonRepositoryProtocol {
    func getDigimonList(page: Int, pageSize: Int) async throws -> DigimonListResponse {
        try await getDigimonList(page: page, pageSize: pageSize, filter: nil)
    }
}
