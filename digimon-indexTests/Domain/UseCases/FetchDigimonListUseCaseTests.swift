//
//  FetchDigimonListUseCaseTests.swift
//  digimon-indexTests
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

import XCTest
@testable import digimon_index

@MainActor
final class FetchDigimonListUseCaseTests: XCTestCase {

    var sut: FetchDigimonListUseCase!
    var mockRepo: MockDigimonRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockRepo = MockDigimonRepository()
        sut = FetchDigimonListUseCase(repository: mockRepo)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockRepo = nil
        try super.tearDownWithError()
    }

    func test_execute_returnsResponseFromRepository() async throws {
        mockRepo.stubbedListResponse = DigimonListResponse.stub()
        
        let response = try await sut.execute(page: 0, pageSize: 8)
        
        XCTAssertEqual(response.content?.count, 1)
        XCTAssertEqual(response.pageable.totalPages, 5)
    }
    
    func test_execute_propagatesRepositoryError() async {
        mockRepo.error = NetworkError.serverError(statusCode: 500)
        do {
            _ = try await sut.execute(page: 0, pageSize: 8)
            XCTFail("Expected error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .serverError(statusCode: 500))
        } catch {
            XCTFail("Wrong error type")
        }
    }
}
