//
//  DigimonSearchFilter.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

struct DigimonSearchFilter: Equatable {
    var name: String?
    var type: TypeFilter?
    var attribute: AttributeFilter?
    var level: LevelFilter?
    var field: FieldFilter?
}

enum TypeFilter: String, CaseIterable, Codable {
    case data = "Data"
}

enum AttributeFilter: String, CaseIterable, Codable {
    case data = "Data"
}

enum LevelFilter: String, CaseIterable, Codable {
    case data = "Data"
}

enum FieldFilter: String, CaseIterable, Codable {
    case data = "Data"
}

