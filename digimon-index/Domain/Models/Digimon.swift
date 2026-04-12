//
//  Digimon.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

struct DigimonListItem: Codable, Equatable {
    let id: Int
    let name: String
    let href: String
    let image: String
}

struct Pageable: Codable, Equatable {
    let currentPage: Int
    let elementsOnPage: Int
    let totalElements: Int
    let totalPages: Int
    let previousPage: String
    let nextPage: String
}

struct DigimonListResponse: Codable, Equatable {
    let content: [DigimonListItem]
    let pageable: Pageable
}
