//
//  MockFetchDigimonDetailUseCase.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

@testable import digimon_index

final class MockFetchDigimonDetailUseCase: FetchDigimonDetailUseCaseProtocol {
    var stubbedResponse: DigimonDetail?
    var error: Error?
    var executeCallCount = 0
    var shouldHang = false
    
    func execute(id: Int) async throws -> DigimonDetail {
        executeCallCount += 1
        if shouldHang {
            try await Task.sleep(nanoseconds: UInt64.max)
        }
        if let error = error { throw error }
        return stubbedResponse!
    }
}
