//
//  DigimonListViewModelTests.swift
//  digimon-indexTests
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

import XCTest
@testable import digimon_index

@MainActor
final class DigimonListViewModelTests: XCTestCase {
    
    var sut: DigimonListViewModel!
    var mockUseCase: MockFetchDigimonListUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockUseCase = MockFetchDigimonListUseCase()
        sut = DigimonListViewModel(fetchDigimonListUseCase: mockUseCase)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockUseCase = nil
        try super.tearDownWithError()
    }
    
    func test_initialState_isEmpty() {
        XCTAssertTrue(sut.digimons.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertTrue(sut.hasMorePages)
    }
    
    func test_fetchDigimons_populatesList() async {
        mockUseCase.stubbedResponse = DigimonListResponse.stub()
        
        await sut.fetchDigimons()
        
        XCTAssertEqual(sut.digimons.count, 1)
        XCTAssertEqual(sut.digimons.first?.name, "Agumon")
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertTrue(sut.hasMorePages)
    }
    
    func test_fetchDigimons_withNewFilter() async {
        mockUseCase.stubbedResponse = DigimonListResponse.stub()
        await sut.fetchDigimons()
        XCTAssertEqual(sut.digimons.count, 1)
        
        mockUseCase.stubbedResponse = DigimonListResponse.stub(id: 2, name: "Greymon")
        await sut.fetchDigimons(filter: DigimonSearchFilter(name: "Greymon"))
        XCTAssertEqual(sut.digimons.count, 1)
        XCTAssertEqual(sut.digimons.first?.name, "Greymon")
    }
    
    func test_fetchNextPage_appendsToExistingList() async {
        mockUseCase.stubbedResponse = DigimonListResponse.stub()
        await sut.fetchDigimons()

        mockUseCase.stubbedResponse = DigimonListResponse.stub(id: 2, name: "Gabumon")
        await sut.fetchNextPage()

        XCTAssertEqual(sut.digimons.count, 2)
        XCTAssertEqual(sut.digimons[0].name, "Agumon")
        XCTAssertEqual(sut.digimons[1].name, "Gabumon")
    }
    
    func test_fetchNextPage_doesNothingWhenNoMorePages() async {
        mockUseCase.stubbedResponse = DigimonListResponse.stub(nextPage: "")
        await sut.fetchDigimons()
        
        mockUseCase.executeCallCount = 0
        await sut.fetchNextPage()
        
        XCTAssertEqual(mockUseCase.executeCallCount, 0)
    }

    func test_fetchDigimons_setsErrorMessageOnFailure() async {
        mockUseCase.error = NetworkError.serverError(statusCode: 500)
        await sut.fetchDigimons()
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.digimons.isEmpty)
        XCTAssertNotNil(sut.errorMessage)
    }
    
}
