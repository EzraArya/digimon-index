//
//  DigimonNetworkServiceTests.swift
//  digimon-indexTests
//
//  Created by Ezra Arya Wijaya on 11/04/26.
//

import XCTest
@testable import digimon_index

@MainActor
final class DigimonNetworkServiceTests: XCTestCase {

    var sut: NetworkService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        sut = NetworkService(session: session)
    }

    override func tearDownWithError() throws {
        sut = nil
        MockURLProtocol.requestHandler = nil
        try super.tearDownWithError()
    }

    func test_request_deliversDecodedObjectOnSuccess() async throws {
        let expectedJSON = """
            {
                "content": [{ "id": 1, "name": "Agumon", "href": "https://...", "image": "https://..." }],
                "pageable": { "currentPage": 0, "elementsOnPage": 1, "totalElements": 1, "totalPages": 1, "previousPage": "", "nextPage": "" }
            }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!, statusCode: 200,
                httpVersion: nil, headerFields: nil
            )!
            return (response, expectedJSON)
        }
        
        let result: DigimonListResponse = try await sut.request(endpoint: .digimonList(page: 0, pageSize: 20))
        
        XCTAssertEqual(result.content?.first?.name, "Agumon")
    }
    
    func test_request_throwsOnServerError() async throws {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!, statusCode: 500,
                httpVersion: nil, headerFields: nil
            )!
            return (response, Data())
        }
        
        do {
            let _: DigimonListResponse = try await sut.request(endpoint: .digimonList(page: 0, pageSize: 20))
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .serverError(statusCode: 500))
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }
    
    func test_request_throwsOnInvalidJSON() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!, statusCode: 200,
                httpVersion: nil, headerFields: nil
            )!
            return (response, "not json".data(using: .utf8)!)
        }
        do {
            let _: DigimonListResponse = try await sut.request(
                endpoint: .digimonList(page: 0, pageSize: 20)
            )
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .decodingFailed)
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }

    func test_request_constructsCorrectURL() async throws {
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.host, "digi-api.com")
            XCTAssertEqual(request.url?.path, "/api/v1/digimon")
            XCTAssertTrue(request.url?.query?.contains("page=0") ?? false)
            XCTAssertTrue(request.url?.query?.contains("pageSize=20") ?? false)
            let response = HTTPURLResponse(
                url: request.url!, statusCode: 200,
                httpVersion: nil, headerFields: nil
            )!
            let data = """
                {"content":[],"pageable":{"currentPage":0,"elementsOnPage":0,"totalElements":0,"totalPages":0,"previousPage":"","nextPage":""}}
                """.data(using: .utf8)!
            return (response, data)
        }
        
        let _: DigimonListResponse = try await sut.request(
            endpoint: .digimonList(page: 0, pageSize: 20)
        )
    }
}
