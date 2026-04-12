//
//  MockDigimonRepository.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

import Foundation
@testable import digimon_index

final class MockDigimonRepository: DigimonRepositoryProtocol {
    var stubbedListResponse: DigimonListResponse?
    var stubbedDetail: DigimonDetail?
    var error: Error?
    
    func getDigimonList(page: Int, pageSize: Int, filter: DigimonSearchFilter?) async throws -> DigimonListResponse {
        if let error = error { throw error }
        return stubbedListResponse!
    }
    
    func getDigimonDetail(id: Int) async throws -> DigimonDetail {
        if let error = error { throw error }
        return stubbedDetail!
    }
}
