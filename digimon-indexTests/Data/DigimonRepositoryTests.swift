//
//  DigimonRepositoryTests.swift
//  digimon-indexTests
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

import XCTest
@testable import digimon_index

@MainActor
final class DigimonRepositoryTests: XCTestCase {
    
    var sut: DigimonRepository!
    var mockNetworkService: MockNetworkService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockNetworkService = MockNetworkService()
        sut = DigimonRepository(networkService: mockNetworkService)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockNetworkService = nil
        try super.tearDownWithError()
    }

    func test_getDigimonList_returnResponseOnSuccess() async throws {
        let expected = DigimonListResponse(
            content: [
                DigimonListItem(id: 1, name: "Agumon", href: "", image: "")
            ],
            pageable: Pageable(currentPage: 0, elementsOnPage: 1, totalElements: 1, totalPages: 1, previousPage: "", nextPage: "")
        )
        
        mockNetworkService.result = expected
        
        let response = try await sut.getDigimonList(page: 0, pageSize: 20)
        
        XCTAssertEqual(response.content.count, 1)
        XCTAssertEqual(response.content.first?.name, "Agumon")
        XCTAssertEqual(response.pageable.currentPage, 0)
    }
    
    func test_getDigimonList_throwsOnNetworkError() async throws {
        mockNetworkService.error = NetworkError.serverError(statusCode: 503)
        
        do {
            _ = try await sut.getDigimonList(page: 0, pageSize: 20)
            XCTFail("Expected error")
        } catch let error as NetworkError {
                    XCTAssertEqual(error, .serverError(statusCode: 503))
        } catch {
            XCTFail("Wrong error type")
        }
    }
    
    func test_getDigimonDetail_returnsDetailOnSuccess() async throws {
        mockNetworkService.result = DigimonDetail.stub()
        let detail = try await sut.getDigimonDetail(id: 1)
        
        XCTAssertEqual(detail.name, "Agumon")
        XCTAssertEqual(detail.levels.first?.level, "Child")
    }
}
