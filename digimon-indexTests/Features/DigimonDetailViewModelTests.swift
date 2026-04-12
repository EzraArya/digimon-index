//
//  DigimonDetailViewModelTests.swift
//  digimon-indexTests
//
//  Created by Ezra Arya Wijaya on 13/04/26.
//

import XCTest
@testable import digimon_index

@MainActor
final class DigimonDetailViewModelTests: XCTestCase {
    
    var sut: DigimonDetailViewModel!
    var mockUseCase: MockFetchDigimonDetailUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockUseCase = MockFetchDigimonDetailUseCase()
        sut = DigimonDetailViewModel(digimonId: 1, fetchDigimonDetailUseCase: mockUseCase)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockUseCase = nil
        try super.tearDownWithError()
    }
    
    func test_initialState_isEmpty() {
        XCTAssertNil(sut.digimon)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_fetchDigimon_populatesDigimonOnSuccess() async {
        mockUseCase.stubbedResponse = DigimonDetail.stub()
        
        await sut.fetchDigimon()
        
        XCTAssertNotNil(sut.digimon)
        XCTAssertEqual(sut.digimon!.name, "Agumon")
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_fetchDigimons_setsErrorMessageOnFailure() async {
        mockUseCase.error = NetworkError.serverError(statusCode: 500)
        await sut.fetchDigimon()
        
        XCTAssertNil(sut.digimon)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.errorMessage)
    }
}
