//
//  DigimonModelTests.swift
//  digimon-indexTests
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

import XCTest
@testable import digimon_index

@MainActor
final class DigimonModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_digimonListItem_decodeFromJSON() throws {
        let json = """
            {
                "id": 1,
                "name": "Agumon",
                "href": "https://digi-api.com/api/v1/digimon/1",
                "image": "https://digi-api.com/images/digimon/w/Agumon.png"
            }
            """.data(using: .utf8)!
        
        let item = try JSONDecoder().decode(DigimonListItem.self, from: json)
        
        XCTAssertEqual(item.id, 1)
        XCTAssertEqual(item.name, "Agumon")
        XCTAssertEqual(item.image, "https://digi-api.com/images/digimon/w/Agumon.png")
    }

    func test_digimonList_decodeFromJSON() throws {
        let json = """
            {
              "content": [
                {
                  "id": 1,
                  "name": "Agumon",
                  "href": "https://digi-api.com/api/v1/digimon/1",
                  "image": "https://digi-api.com/images/digimon/w/Agumon.png"
                },
                {
                  "id": 2,
                  "name": "Airdramon",
                  "href": "https://digi-api.com/api/v1/digimon/2",
                  "image": "https://digi-api.com/images/digimon/w/Airdramon.png"
                },
                {
                  "id": 3,
                  "name": "Angemon",
                  "href": "https://digi-api.com/api/v1/digimon/3",
                  "image": "https://digi-api.com/images/digimon/w/Angemon.png"
                },
                {
                  "id": 4,
                  "name": "Betamon",
                  "href": "https://digi-api.com/api/v1/digimon/4",
                  "image": "https://digi-api.com/images/digimon/w/Betamon.png"
                },
                {
                  "id": 5,
                  "name": "Birdramon",
                  "href": "https://digi-api.com/api/v1/digimon/5",
                  "image": "https://digi-api.com/images/digimon/w/Birdramon.png"
                }
              ],
              "pageable": {
                "currentPage": 0,
                "elementsOnPage": 5,
                "totalElements": 1488,
                "totalPages": 297,
                "previousPage": "",
                "nextPage": "https://digi-api.com/api/v1/digimon?page=1"
              }
            }
            """.data(using: .utf8)!
        
        let response = try JSONDecoder().decode(DigimonListResponse.self, from: json)
        
        XCTAssertEqual(response.content?.count, 5)
        XCTAssertEqual(response.content?.first?.name, "Agumon")
        XCTAssertEqual(response.pageable.currentPage, 0)
    }

}
