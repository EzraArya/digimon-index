//
//  DigimonDetail.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

struct DigimonDetail: Codable {
    let id: Int
    let name: String
    let xAntibody: Bool
    let images: [DigimonImage]
    let levels: [DigimonLevel]
    let types: [DigimonType]
    let attributes: [DigimonAttribute]
    let fields: [DigimonField]
    let releaseDate: String
    let descriptions: [DigimonDescription]
    let skills: [DigimonSkill]
    let priorEvolutions: [DigimonEvolution]
    let nextEvolutions: [DigimonEvolution]
}

struct DigimonImage: Codable, Equatable {
    let href: String
    let transparent: Bool
}

struct DigimonLevel: Codable, Equatable {
    let id: Int
    let level: String
}

struct DigimonType: Codable, Equatable {
    let id: Int
    let type: String
}

struct DigimonAttribute: Codable, Equatable {
    let id: Int
    let attribute: String
}

struct DigimonField: Codable, Equatable {
    let id: Int
    let field: String
    let image: String
}

struct DigimonDescription: Codable, Equatable {
    let origin: String
    let language: String
    let description: String
}

struct DigimonSkill: Codable, Equatable {
    let id: Int
    let skill: String
    let translation: String
    let description: String
}

struct DigimonEvolution: Codable, Equatable {
    let id: Int
    let digimon: String
    let condition: String
    let image: String
    let url: String
}
