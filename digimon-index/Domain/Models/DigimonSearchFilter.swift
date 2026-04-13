//
//  DigimonSearchFilter.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

struct DigimonSearchFilter: Equatable {
    var name: String?
    var xAntibody: Bool?
    var attribute: AttributeFilter?
    var level: LevelFilter?
}

enum AttributeFilter: String, CaseIterable, Codable {
    case data = "Data"
}

enum LevelFilter: String, CaseIterable, Codable {
    case data = "Data"
}
