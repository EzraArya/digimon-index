//
//  FetchDigimonDetailUseCaseTests.swift
//  digimon-indexTests
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

import XCTest
@testable import digimon_index

@MainActor
final class FetchDigimonDetailUseCaseTests: XCTestCase {

    var sut: FetchDigimonDetailUseCase!
    var mockRepo: MockDigimonRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockRepo = MockDigimonRepository()
        sut = FetchDigimonDetailUseCase(repository: mockRepo)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockRepo = nil
        try super.tearDownWithError()
    }

    func test_execute_returnsResponseFromRepository() async throws {
        mockRepo.stubbedDetail = DigimonDetail.stub()
        
        let response = try await sut.execute(id: 1)
        
        XCTAssertEqual(response.id, 1)
        XCTAssertEqual(response.name, "Agumon")
    }
    
    func test_execute_propagatesRepositoryError() async {
        mockRepo.error = NetworkError.serverError(statusCode: 500)
        do {
            _ = try await sut.execute(id: 1)
            XCTFail("Expected error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .serverError(statusCode: 500))
        } catch {
            XCTFail("Wrong error type")
        }
    }

}
