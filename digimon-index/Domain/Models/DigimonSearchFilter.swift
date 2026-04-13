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
    case free = "Free"
    case virus = "Virus"
    case vaccine = "Vaccine"
    case unknown = "Unknown"
    case variable = "Variable"
    case noData = "No Data"
}

enum LevelFilter: String, CaseIterable, Codable {
    case babyII = "Baby II"
    case adult = "Adult"
    case perfect = "Perfect"
    case child = "Child"
    case babyI = "Baby I"
    case ultimate = "Ultimate"
    case armor = "Armor"
    case unknown = "Unknown"
    case hybrid = "Hybrid"
}
